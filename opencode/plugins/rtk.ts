import type { Plugin } from "@opencode-ai/plugin"

// RTK OpenCode plugin — rewrites commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

// Commands that NEVER benefit from `rtk rewrite` — skipping the subprocess
// fork (~40-170ms per bash call, more under load) removes the lag on these
// fast, synchronous operations so they execute and return immediately.
//
// - pkill / kill / killall / pgrep: process-signal commands. `rtk rewrite`
//   always exits 1 with no output for these (verified: no RTK equivalent),
//   so the fork is pure overhead on every invocation.
// - cat: `rtk rewrite "cat <file>"` maps to `rtk read <file>`, which adds a
//   second process spawn plus output filtering/summarizing. For file dumps
//   (especially large files / pipes like `cat x | head`) that post-processing
//   is exactly the "long delay before proceed". Native `cat` (or the Read
//   tool) streams immediately, so bypass the rewrite deliberately — speed over
//   token savings here.
const SKIP_REWRITE = new Set(["pkill", "kill", "killall", "pgrep", "cat"])

// Leading wrappers that don't change which binary ultimately runs.
const WRAPPERS = new Set([
  "sudo",
  "doas",
  "run0",
  "env",
  "nice",
  "nohup",
  "command",
  "builtin",
  "timeout",
])

// Unwrap leading wrappers (sudo/env/timeout/…) to the real binary name.
// Supports `timeout 10 <cmd>`, `timeout -s KILL 10 <cmd>`, `env FOO=1 <cmd>`.
function stripWrappers(tokens: string[]): string[] {
  let rest = tokens
  for (;;) {
    const head = (rest[0] ?? "").toLowerCase()
    if (!WRAPPERS.has(head)) return rest
    rest = rest.slice(1)
    if (head === "timeout") {
      // Drop flags (and their values) plus the single duration operand.
      while (rest.length > 0 && rest[0].startsWith("-")) {
        const flag = rest[0]
        rest = rest.slice(1)
        // -s/--signal, --preserve-status takes a value; -k/--kill-after too.
        if (/^(-s|--signal|-k|--kill-after)$/.test(flag)) rest = rest.slice(1)
      }
      rest = rest.slice(1) // duration operand
    } else if (head === "env" || head === "nice") {
      // Drop VAR=... assignments, bare flags (-i, -n), and flags with values
      // (-u VAR, --unset=VAR, --adjustment N).
      while (rest.length > 0 && (/=/.test(rest[0]) || rest[0].startsWith("-"))) {
        const flag = rest[0]
        rest = rest.slice(1)
        if ((head === "env" && /^(-u|--unset)$/.test(flag)) || flag === "-n") {
          rest = rest.slice(1)
        }
      }
    } else if (head === "sudo" || head === "doas" || head === "run0") {
      while (rest.length > 0 && rest[0].startsWith("-")) {
        const flag = rest[0]
        rest = rest.slice(1)
        // -u/--user and -g/--group consume the next token.
        if (/^(-u|--user|-g|--group)$/.test(flag)) rest = rest.slice(1)
      }
    }
    if (rest.length === 0) return rest
  }
}

// True when the command starts with a SKIP_REWRITE binary, so the plugin can
// return early without spawning `rtk rewrite`. Quoted leading words
// (`"cat" file`) and wrapper prefixes (`sudo pkill …`) are handled. Only the
// leading command is considered: `echo cat` correctly does NOT skip.
function shouldSkipRewrite(command: string): boolean {
  const trimmed = command.trim()
  if (!trimmed) return true
  const firstChunk = trimmed.split(/[;&|]+/)[0].trim()
  if (!firstChunk) return true
  const tokens = firstChunk.split(/\s+/).filter(Boolean)
  const rest = stripWrappers(tokens)
  const head = (rest[0] ?? "").replace(/^['"]+|['"]+$/g, "").toLowerCase()
  return SKIP_REWRITE.has(head)
}

const rewriteCache = new Map<string, string>()
// Guard so a stalled `rtk` binary can never block bash indefinitely.
const REWRITE_TIMEOUT_MS = 1500
export const RtkOpenCodePlugin: Plugin = async ({ $ }) => {
  try {
    await $`which rtk`.quiet()
  } catch {
    console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
    return {}
  }

  return {
    "tool.execute.before": async (input, output) => {
      const tool = String(input?.tool ?? "").toLowerCase()
      if (tool !== "bash" && tool !== "shell") return
      const args = output?.args
      if (!args || typeof args !== "object") return

      const command = (args as Record<string, unknown>).command
      if (typeof command !== "string" || !command) return

      // Fast path: pkill/kill/cat (and family) never benefit from a rewrite —
      // skip the `rtk rewrite` fork entirely so they execute immediately.
      if (shouldSkipRewrite(command)) return

      try {
        let rewritten = rewriteCache.get(command)
        if (rewritten === undefined) {
          const rewrite = $`rtk rewrite ${command}`.quiet().nothrow()
          const timeout = new Promise<null>((resolve) =>
            setTimeout(() => resolve(null), REWRITE_TIMEOUT_MS),
          )
          const result = await Promise.race([rewrite, timeout])
          if (result === null) {
            // Timed out — pass through unchanged; never block bash on rtk.
            return
          }
          rewritten = String(result.stdout).trim()
          rewriteCache.set(command, rewritten || command)
        }
        if (rewritten && rewritten !== command) {
          ;(args as Record<string, unknown>).command = rewritten
        }
      } catch {
        // rtk rewrite failed — pass through unchanged
      }
    },
  }
}
