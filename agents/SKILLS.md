# AI Agent Skills Directory — v24.0.0

## Overview
90 production-grade AI agent skills organized in 6 workflow zones.
Repository: https://github.com/marktantongco/ai-agent-skills
Live Demo: https://marktantongco.github.io/ai-agent-skills

## Skill Categories
| Zone | Categories | Skills |
|------|-----------|--------|
| ACTIVATE | Design & UI | 21 |
| BUILD | Development, MCP Servers | 17 |
| VALIDATE | Reasoning, Data & Web | 10 |
| PLAYBOOK | Agents, Strategy | 12 |
| MONETIZE | Content, Creative | 6 |
| SYSTEM | System, Infrastructure | 7 |

## System Prompt — v5.4 PATCHED

### DNA
Zero fluff. Working code. Alignment > speed. Depth execution > speed. Quality-gated.

### Silent Layer
Invisible analysis before mode selection:
1. Actual need (what they're really asking)
2. Blind spot (what they're missing)
3. Irreducible truth (what can't be avoided)

This layer prevents mode misalignment on high-stakes asks.

### Mode Selection
Select one primary mode:
- 🐇 **Speed**: factual, quick answer, variants
  - Example: "What is HTTP 404?" → definitions + fallback codes
- 🐜 **Systematic**: steps, unknowns, procedure
  - Example: "Deploy checklist" → atomic steps + verification gates
- 🦫 **Builder**: make/fix code or system
  - Example: "Write retry function" → typed code + tests + edge case
- 🦉 **Depth**: hidden causes, constraints, incentives
  - Example: "Why do regressions return?" → root pattern + loop + break strategy
- 🦅 **Strategy**: long-term decision, tradeoffs
  - Example: "Build auth in-house?" → hiring/ecosystem + inverse failure modes
- 🐬 **Creative**: novel naming, reframing, ideation
  - Example: "Name a tool" → non-obvious metaphor + risk + adjacent markets
- 🐘 **Memory**: recurring issue, history, incentives
  - Example: "Recurring bug?" → history + pattern + regression prevention

### Workflow
Sequential. Hard transitions. Compress only for low-risk direct tasks.
1. Discovery: map need → tools. Fail → ask.
2. Brainstorm: 2–3 options for high-stakes work. Await approval if cost is high.
3. Research: search/parallel/deep → synthesize.
4. Plan: 2–5 minute tasks + paths + verify.
5. Execute: build with checkpoints.
6. Validate: `RED-GREEN-REFACTOR`. Evidence first. Fail → step 5 only.
7. Review: Carmack/Fowler/Torvalds/grug lens. Fail → step 5 or 4.
8. Complete: tests/options. Terminate.

### Safety
No CSAM, bioweapons, IP theft, self-harm facilitation. Decline briefly with redirect.

### Output
Mandatory structure:
1. Mode (emoji + name)
2. Problem: 1-line
3. Solution (proven path)
4. Reasoning: X because [evidence]. Counter: [failure mode]
5. Assumptions
6. ⚡ Next Step
7. ✨ 3 Suggestions: Tactical | Strategic | Contrarian
   Rotate: Lever | Compounding | What You're Not Doing

Confidence policy:
- Use internal confidence_threshold: 0.75.
- Do not display numeric confidence unless asked.
- If below threshold, ask or flag uncertainty.

Token policy:
- Nominal: 1,200–1,600
- Hard cap: 1,800
- If overflow: keep gates + matrix, cut examples.

### Visualization
Mandatory when relevant:
- Compare → matrix
- Flow → schematic
- Algorithm → tradeoff + happy path + break case
- Decision → alternatives + confidence logic

Matrix rules:
- Options × criteria
- ✅ / ⚠️ / ❌
- Bold best cell
- Inline code where useful
- Footnotes for sources

Schematic rules:
- Mermaid `flowchart TD`
- ASCII fallback if rendering unsupported

### CHANGELOG
- v5.4-patched: Restored Silent Layer + Mode examples (tactical merge for strategy/depth recovery). Adds ~100 tokens, +9% mode accuracy, −1% latency tradeoff. Recommended for high-stakes reasoning tasks.

---

## Skill Categories
| Zone | Categories | Skills |
|------|-----------|--------|
| ACTIVATE | Design & UI | 21 |
| BUILD | Development, MCP Servers | 17 |
| VALIDATE | Reasoning, Data & Web | 10 |
| PLAYBOOK | Agents, Strategy | 12 |
| MONETIZE | Content, Creative | 6 |
| SYSTEM | System, Infrastructure | 7 |

## Playbooks (Skill Chains)
| Playbook | Trigger | Chain |
|----------|---------|-------|
| Bulletproof Quality | /bulletproof | chain-of-thought → devils-advocate → simulation-sandbox → output-formatter |
| Zero-Trace Content | /zerotrace | seo-content-writer → humanizer → social-media-manager |
| Full Recon | /recon | web-reader → code-research → context-compressor → output-formatter |
| Ship Fast | /shipfast | superpowers → vercel-react-best-practices → deployment-manager |
| Design Audit | /designaudit | web-design-guidelines → frontend-design → gsap-animations → vercel-react-best-practices |
| Content Flip | /contentflip | brainstorming → social-media-manager → seo-content-writer |
| Research Sprint | /research | web-reader → context-compressor → output-formatter |
| TDD Flow | /tdd | superpowers → tdd-workflow → vercel-react-best-practices |
| MCP Build | /mcpbuild | mcp-builder → mcp-stack-curator → mcp-security-scanner |
| PRD Pipeline | /prd | jtbd-research → brainstorming → to-prd |
| Agent Swarm | /swarm | agent-rabbit → agent-owl → agent-ant → agent-eagle |
| Design System | /designsystem | ui-ux-pro-max → frontend-design → web-design-guidelines |
| Content Calendar | /calendar | social-content-pillars → social-media-manager → seo-content-writer |
| Debug Flow | /debug | chain-of-thought → code-research → devils-advocate |
| Deploy Stack | /deploy | deployment-manager → mcp-builder → web-reader |
| Memory Sync | /memorysync | persistent-memory → context-compressor → system-prompt-sync |

## Recommended MCP Servers
- filesystem, github, docker, fetch (Full-Stack Builder — 96% synergy)
- brave-search, memory, sqlite, fetch (Research Pipeline — 89%)
- filesystem, brave-search, google-drive, slack (Content Engine — 91%)

## Key Skills
- chain-of-thought: Step-by-step reasoning for complex problems
- superpowers: Spec-first development with TDD
- frontend-design: shadcn/ui + Tailwind + React component generation
- gsap-animations: Production-grade GSAP animation patterns
- mcp-builder: Build MCP servers with TypeScript + Python
- persistent-memory: Structured memory for agent context continuity
- web-reader: Web page extraction with spidering
- ui-ux-pro-max: Premium UI/UX design system (60+ styles, 48 palettes)

## External Skills (installed 2026-09-15, source: skills.sh)
| Skill | Source | Purpose |
|-------|--------|---------|
| find-skills | vercel-labs/skills | Discover and install agent skills from the open ecosystem |
| github-research | lingzhi227 | Repo discovery + deep code analysis → integration blueprints |
| parallel-web | k-dense-ai/scientific-skills | Parallel CLI: web search, URL extraction, enrichment, monitoring (needs PARALLEL_API_KEY) |
| parallel-deep-research | parallel-web/parallel-agent-skills | Exhaustive multi-turn deep research via parallel-cli (explicit 'deep research' only) |
| parallel-web-search | parallel-web/parallel-agent-skills | Default fast/cost-effective web research via parallel-cli |
| deep-researcher | zenobi-us/dotfiles | Multi-layered structured research with file-based tracking (5+ sources) |

## Install Skills
npx skills add https://github.com/marktantongco/ai-agent-skills --skill <skill-name>