import type { Plugin } from "@opencode-ai/plugin"

export const FreebuffOpenCodePlugin: Plugin = async ({ $ }) => {
  try {
    await $`which freebuff-unified`.quiet()
  } catch {
    console.warn("[freebuff] freebuff-unified binary not found in PATH — plugin disabled")
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

      // Check if command involves LLM/model operations - if so, offer Freebuff integration
      const lowerCmd = command.toLowerCase()
      if (
        lowerCmd.includes("git") ||
        lowerCmd.includes("status") ||
        lowerCmd.includes("build") ||
        lowerCmd.includes("run") ||
        lowerCmd.includes("compile") ||
        lowerCmd.includes("test") ||
        lowerCmd.includes("deploy")
      ) {
        // For engineering commands, we can optionally prepend with Freebuff context check
        // This is a hook that could integrate with the Freebuff engine for
        // token-aware command execution via RTK
      }

      // health check removed: was unconditional curl per bash (15ms+fork) with no effect
      // if Freebuff integration needed, gate behind meaningful lowerCmd check and cache result
    },

    "tool.execute.after": async (input, output) => {
      // Post-execution: could log Freebuff engine interactions, token usage, etc.
      const tool = String(input?.tool ?? "").toLowerCase()
      if (tool !== "bash" && tool !== "shell") return
      const args = (input as any)?.args ?? (output as any)?.args
      if (!args || typeof args !== "object") return

      const command = (args as Record<string, unknown>).command
      if (typeof command !== "string" || !command) return

      const lowerCmd = command.toLowerCase()
      // For RTK-integrated commands, we could track Freebuff engine usage
      if (lowerCmd.startsWith("rtk")) {
        // RTK commands are already token-optimized; could sync with Freebuff state
      }
    },
  }
}
// hot-reload trigger 2026-09-05