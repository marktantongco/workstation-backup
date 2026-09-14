package proxy

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"unicode/utf8"
)

// Payload guard, ported from petehsu/KiroProxy:
//   - Kiro's CodeWhisperer data plane rejects conversation payloads larger
//     than 6144 KiB (6,290,560 bytes) with an opaque error; KiroProxy guards
//     against it by measuring the serialized payload up front.
//   - A single text content payload should stay below 300 KiB (KiroProxy
//     truncates over-long blocks there); bigger blocks risk the same opaque
//     rejection and inflate the serialized body past the total cap.
//
// The guard runs on the translated Kiro body — the exact bytes dispatchKiro
// would send — so oversized requests fail fast with a clear, actionable error
// instead of burning a pool account, a retry cycle, and a rate-limit cooldown
// on a request that can never succeed.

const (
	kiroMaxPayloadBytes = 6144 * 1024 // 6144 KiB serialized conversation cap
	kiroMaxBlockBytes   = 300 * 1024  // 300 KiB largest single text block cap
)

// kiroPayloadReport summarizes what the guard measured.
type kiroPayloadReport struct {
	TotalBytes  int
	MaxBlock    int
	MaxBlockLoc string // where the biggest block lives, for error messages
}

// measureKiroPayload walks the translated Kiro body and reports the serialized
// size plus the largest single text payload (current message + history entries,
// including tool results). Non-UTF8 blocks are flagged too: the data plane
// rejects invalid UTF-8 with the same opaque error.
func measureKiroPayload(kiroBody []byte) kiroPayloadReport {
	rep := kiroPayloadReport{TotalBytes: len(kiroBody)}

	var top struct {
		ConversationState struct {
			CurrentMessage struct {
				UserInputMessage struct {
					Content                 string `json:"content"`
					UserInputMessageContext struct {
						ToolResults []struct {
							ToolResultId  string `json:"toolResultId"`
							Content       string `json:"content"`
							ContentString string `json:"contentString"`
						} `json:"toolResults"`
					} `json:"userInputMessageContext"`
				} `json:"userInputMessage"`
			} `json:"currentMessage"`
			History []json.RawMessage `json:"history"`
		} `json:"conversationState"`
	}
	if err := json.Unmarshal(kiroBody, &top); err != nil {
		return rep // unparseable: dispatch will surface the real error
	}

	check := func(text, loc string) {
		n := len(text)
		if n > rep.MaxBlock {
			rep.MaxBlock = n
			rep.MaxBlockLoc = loc
		}
	}

	cur := top.ConversationState.CurrentMessage.UserInputMessage
	check(cur.Content, "currentMessage.userInputMessage.content")
	if !utf8.ValidString(cur.Content) {
		rep.MaxBlockLoc = "currentMessage.userInputMessage.content (invalid UTF-8)"
	}
	for i, tr := range cur.UserInputMessageContext.ToolResults {
		check(tr.Content, fmt.Sprintf("currentMessage toolResults[%d].content", i))
		check(tr.ContentString, fmt.Sprintf("currentMessage toolResults[%d].contentString", i))
	}
	for i, raw := range top.ConversationState.History {var entry map[string]json.RawMessage
			if json.Unmarshal(raw, &entry) != nil {
				continue
			}
			for kind, inner := range entry { // userInputMessage | assistantResponseMessage
				if kind == "userInputMessage" { //nolint:staticcheck // map key from wire format
				var uim struct {
					Content                 string `json:"content"`
					UserInputMessageContext struct {
						ToolResults []struct {
							Content       string `json:"content"`
							ContentString string `json:"contentString"`
						} `json:"toolResults"`
					} `json:"userInputMessageContext"`
				}
				if json.Unmarshal(inner, &uim) == nil {
					check(uim.Content, fmt.Sprintf("history[%d].userInputMessage.content", i))
					for j, tr := range uim.UserInputMessageContext.ToolResults {
						check(tr.Content, fmt.Sprintf("history[%d] toolResults[%d].content", i, j))
						check(tr.ContentString, fmt.Sprintf("history[%d] toolResults[%d].contentString", i, j))
					}
				}
			} else if kind == "assistantResponseMessage" {
				var arm struct {
					Content string `json:"content"`
				}
				if json.Unmarshal(inner, &arm) == nil {
					check(arm.Content, fmt.Sprintf("history[%d].assistantResponseMessage.content", i))
				}
			}
		}
	}
	return rep
}

// guardKiroPayload enforces the upstream limits. ok=false means the request
// must not be dispatched; errText explains what to fix.
func guardKiroPayload(kiroBody []byte) (ok bool, errText string) {
	rep := measureKiroPayload(kiroBody)
	if rep.TotalBytes > kiroMaxPayloadBytes {
		return false, fmt.Sprintf(
			"payload too large for Kiro upstream: %d bytes exceeds the 6144 KiB limit by %d bytes; trim conversation history, shrink tool outputs, or start a new session",
			rep.TotalBytes, rep.TotalBytes-kiroMaxPayloadBytes)
	}
	if rep.MaxBlock > kiroMaxBlockBytes {
		return false, fmt.Sprintf(
			"single content block too large for Kiro upstream: %s is %d bytes (limit 300 KiB); truncate the tool output or split the message",
			rep.MaxBlockLoc, rep.MaxBlock)
	}
	return true, ""
}

// stickyKeyFromText derives a stable sticky key from the most recent user
// input. Multi-turn agent loops repeat the conversation with the same latest
// user message, so equal text ⇒ same conversation ⇒ same preferred account.
func stickyKeyFromText(text string) string {
	sum := sha256.Sum256([]byte(text))
	return hex.EncodeToString(sum[:12])
}

// lastUserText extracts the current message content from a translated Kiro
// body for sticky key derivation. Returns "" when the body is malformed;
// callers treat that as "no sticky key" and fall back to plain rotation.
func lastUserText(kiroBody []byte) string {
	var top struct {
		ConversationState struct {
			CurrentMessage struct {
				UserInputMessage struct {
					Content string `json:"content"`
				} `json:"userInputMessage"`
			} `json:"currentMessage"`
		} `json:"conversationState"`
	}
	if err := json.Unmarshal(kiroBody, &top); err != nil {
		return ""
	}
	return top.ConversationState.CurrentMessage.UserInputMessage.Content
}
