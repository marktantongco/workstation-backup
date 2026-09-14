package proxy

import (
	"encoding/json"
	"strings"
	"testing"
)

func TestGuardKiroPayloadAcceptsNormalRequest(t *testing.T) {
	body := []byte(`{"profileArn":"p","conversationState":{"conversationId":"c","history":[{"userInputMessage":{"content":"hi"}}],"currentMessage":{"userInputMessage":{"content":"hello"}},"chatTriggerType":"MANUAL"}}`)
	ok, why := guardKiroPayload(body)
	if !ok {
		t.Fatalf("guard rejected normal payload: %s", why)
	}
}

func TestGuardKiroPayloadRejectsOversizedTotal(t *testing.T) {
	big := strings.Repeat("x", 6144*1024+1024)
	body, _ := json.Marshal(map[string]any{
		"conversationState": map[string]any{
			"currentMessage": map[string]any{"userInputMessage": map[string]any{"content": big}},
		},
	})
	ok, why := guardKiroPayload(body)
	if ok {
		t.Fatal("guard accepted oversized payload")
	}
	if !strings.Contains(why, "6144 KiB") {
		t.Fatalf("error message missing cap: %s", why)
	}
}

func TestGuardKiroPayloadRejectsOversizedBlock(t *testing.T) {
	// Total under the 6144 KiB cap, single block over the 300 KiB cap.
	big := strings.Repeat("y", 301*1024)
	body, _ := json.Marshal(map[string]any{
		"conversationState": map[string]any{
			"currentMessage": map[string]any{"userInputMessage": map[string]any{"content": big}},
		},
	})
	ok, why := guardKiroPayload(body)
	if ok {
		t.Fatal("guard accepted oversized block")
	}
	if !strings.Contains(why, "currentMessage.userInputMessage.content") {
		t.Fatalf("error message missing block location: %s", why)
	}
}

func TestGuardKiroPayloadFlagsToolResultBlock(t *testing.T) {
	big := strings.Repeat("z", 301*1024)
	body, _ := json.Marshal(map[string]any{
		"conversationState": map[string]any{
			"currentMessage": map[string]any{"userInputMessage": map[string]any{
				"content": "run tool",
				"userInputMessageContext": map[string]any{
					"toolResults": []map[string]any{{"toolResultId": "t1", "content": big}},
				},
			}},
		},
	})
	ok, why := guardKiroPayload(body)
	if ok {
		t.Fatal("guard accepted oversized tool result")
	}
	if !strings.Contains(why, "toolResults[0]") {
		t.Fatalf("error message missing toolResult location: %s", why)
	}
}

func TestLastUserTextAndStickyKey(t *testing.T) {
	body := []byte(`{"conversationState":{"currentMessage":{"userInputMessage":{"content":"turn-1"}}}}`)
	if got := lastUserText(body); got != "turn-1" {
		t.Fatalf("lastUserText = %q", got)
	}
	k1 := stickyKeyFromText("turn-1")
	k2 := stickyKeyFromText("turn-1")
	k3 := stickyKeyFromText("turn-2")
	if k1 != k2 || k1 == k3 {
		t.Fatalf("sticky key not stable/discriminating: %s %s %s", k1, k2, k3)
	}
	if got := lastUserText([]byte("not json")); got != "" {
		t.Fatalf("lastUserText on garbage = %q, want empty", got)
	}
}
