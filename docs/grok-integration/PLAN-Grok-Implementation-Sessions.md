# PLAN.md: Implementation Session Prompt — Grok Integration into Nextcloud + Firefox (AIDE_OS)

**Purpose**: This prompt guides focused implementation sessions for building the Grok Web + Grok Build complementary workflow inside a Nextcloud-centric environment accessed via Firefox on the M93p thin client. It is designed for use with Grok (or similar) in a structured, phased manner aligned with DESIGN.md.

**Core Constraints (from user decisions)**:
- **Primary focus**: Seamless browser-centric integration of Grok Web and Grok Build as the core AI feature of AIDE_OS.
  - Grok Web (pinned tab): Search, Plan, Brainstorm, Context Generation. Key outputs are manually exported to Nextcloud (persistent shared memory).
  - Grok Build (local CLI on UM690): Build, Code, Organize, Local Cluster Orchestration. Invoked via web terminal, n8n, or future ACP with explicit human-in-the-loop handoff.
- M93p is a thin-client browser surface only. All heavy services (Nextcloud, Ollama, Grok Build, n8n) run on the UM690 control plane and are accessed via Tailscale.
- Fully eliminate Obsidian. Invest in Nextcloud Collectives + Vector DB + Firefox productivity extensions.
- Local-first AI preference (Ollama + parllama TUI) for sensitive work; Grok Build used for its agentic depth.
- Privacy: Apply strict `.gitignore` + Grok Build config toggles while retaining full Grok web connectivity.
- Documents remain higher-level with references. Phased approach is mandatory.

---

## Session Guidelines (Always Follow)

1. **Work strictly in phases** as defined in DESIGN.md. Do not jump ahead.
2. **Center every decision on the complementary Grok Web + Grok Build workflow** and the human-in-the-loop handoff via Nextcloud.
3. Prioritize local-first and sovereignty. Default to solutions on the UM690.
4. Higher-level guidance with key commands, config patterns, and official references. Full scripts only when requested.
5. At the start of each session, confirm current state of the M93p browser surface and UM690 services.
6. Always include privacy considerations when Grok Build is discussed.
7. After major steps, provide verification checks and note any updates needed for DESIGN.md.

---

## Phase 1: Foundation — Nextcloud + Firefox Browser Surface

**Objective**: Establish a stable, locked-down but productive Firefox session on the M93p that serves as the browser-centric control UI focused on Nextcloud. This surface must be ready to host the Grok workflow (pinned Grok Web tab + web terminal to UM690).

**Key Tasks**:
- Install Ubuntu Server 26.04 LTS minimal on the M93p.
- Configure a clean display environment (ubuntu-frame recommended) that launches Firefox maximized.
- Create a dedicated Firefox profile locked down with `policies.json` (settings, menus, downloads, and extension control).
- Install and configure productivity extensions (Sidebery or Tree Style Tab for sidebars/vertical tabs + tiling tools).
- Set up pinned tabs / bookmarks for: Nextcloud Text, Talk, Dashboard, Web Terminal (to UM690), Grok Web, and future AI surfaces.
- Apply basic Tokyo Night Storm Dark / AIDE_OS theming via userChrome.css and Nextcloud theme.
- Verify that the browser surface is usable for daily Nextcloud work and ready for AI integration.

**Success Criteria**:
- M93p provides a reliable browser window focused on Nextcloud.
- Pinned access to Grok Web and a web terminal to the UM690 is available.
- Strong lockdown of settings/menus is in place without destroying productivity features.

**References**:
- Firefox enterprise policies: Mozilla documentation.
- Sidebery / Tree Style Tab + userChrome.css patterns for clean layouts.
- ubuntu-frame documentation (Canonical) for Ubuntu 26.04 kiosk-style surfaces.

**Next Session Prompt Seed**: "Phase 1 browser surface is complete and stable. Begin Phase 2 local-first AI integration..."

---

## Phase 2: Local-First AI + Enhanced PKM

**Objective**: Make local AI feel native inside the Firefox + Nextcloud environment and restore (or surpass) the linking/RAG capabilities previously provided by Obsidian.

**Key Tasks**:
- On UM690: Deploy Ollama + **parllama** (or equivalent dedicated CLI TUI) for model management, quantization, and container guardrails.
- Expose a local chat/RAG surface (Open WebUI or best current Nextcloud-compatible option) as a pinned tab in Firefox.
- Deploy **Nextcloud Collectives** for structured knowledge linking.
- Stand up a Vector DB (Qdrant preferred) + n8n indexing pipeline so local models can perform semantic search over Nextcloud files and notes.
- Refine theming and Dashboard widgets so the AI surfaces feel cohesive with the rest of the AIDE_OS aesthetic.
- Document the basic human workflow for using local AI alongside Grok Web.

**Success Criteria**:
- User can chat with notes and files locally from within the Firefox session.
- Semantic RAG and structured linking are available without Obsidian.
- Local AI management is clean and controllable via parllama TUI on the control plane.

**References**:
- Ollama + parllama documentation.
- Nextcloud Collectives app.
- Qdrant / pgvector + n8n integration patterns for document RAG.

**Next Session Prompt Seed**: "Phase 2 local AI and PKM enhancements are complete. Proceed to Phase 3 deep Grok Build integration..."

---

## Phase 3: Deep Grok Build Integration (Core of AIDE_OS)

**Objective**: Make the complementary Grok Web + Grok Build workflow feel seamless and reliable when directed from the Firefox browser surface. This is the primary AI capability of AIDE_OS.

**Key Tasks**:
- Install Grok Build CLI on the UM690 using the official method. Authenticate with SuperGrok account.
- Apply privacy mitigations: strict `.gitignore` patterns + configuration toggles in `~/.grok/config.toml` (or environment variables). Test upload behavior.
- Create AIDE_OS helper scripts / personas for consistent invocation (interactive TUI via web terminal and headless via n8n).
- Build or document the standard human-in-the-loop handoff process (export from Grok Web → Nextcloud context note → invoke Grok Build with explicit reference to that note + project paths).
- Create reusable Nextcloud templates/checklists for context handoff and session logging.
- Optional deeper integration: Explore ACP (`grok agent stdio`) for tighter embedding if the explicit workflow proves insufficient.
- Practice end-to-end workflows (planning in Grok Web → execution on UM690 via Grok Build → results visible in Nextcloud).

**Success Criteria**:
- A user working in the Firefox session can reliably move from Grok Web planning to Grok Build execution and back, with Nextcloud serving as the durable shared memory.
- Privacy mitigations are in place and verified.
- The workflow is documented inside Nextcloud as part of AIDE_OS and feels natural for daily use and cluster orchestration tasks.

**References**:
- Official Grok Build docs: https://x.ai/cli and https://docs.x.ai/build/overview
- Headless mode, session management (`--session-id`, `--resume`), ACP.
- Privacy configuration guidance from Grok Build documentation.

**Next Session Prompt Seed**: "Phase 3 Grok integration is operational. Refine workflows, add automation, or expand AIDE_OS personas as needed."

---

## General Notes for All Sessions
- Always prefer solutions that keep the human in explicit control of context handoff.
- Treat Nextcloud folders as the system of record for plans, context, and results.
- When working on the UM690, prefer limited/service users for Grok Build and log invocations for auditability.
- Update DESIGN.md if significant architectural decisions change during implementation.
