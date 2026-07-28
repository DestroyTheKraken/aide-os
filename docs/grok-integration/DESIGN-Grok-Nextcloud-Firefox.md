# DESIGN.md: Grok Integration into Nextcloud + Firefox (AIDE_OS)

**Version**: 1.1  
**Date**: 2026-07-14  
**Author**: Grok-assisted design for Joshua Hickman (hickmanserver / AIDE_OS)  
**Primary Goal**: Design a seamless, browser-centric workflow that deeply integrates **Grok Web** and **Grok Build** into a Nextcloud-powered environment accessed via Firefox. This becomes the core AI capability of **AIDE_OS**, fully replacing the previous Obsidian + Buildian/Grimoire stack.

The M93p acts as a thin-client browser surface. All heavy compute (Nextcloud, Ollama, Grok Build, n8n) lives on the UM690 control plane. The human remains in the loop for context handoff and oversight.

---

## 1. Executive Summary & Design Principles

This design makes **Grok Web + Grok Build** the primary AI system inside a sovereign Nextcloud environment, accessed through a locked-down but feature-rich Firefox browser on the M93p thin client.

**Core Principles**:
- **Nextcloud is the single source of truth and persistent shared memory**. All plans, context, results, and documentation live in versioned Nextcloud notes/folders.
- **Complementary Grok roles** (official strengths as of July 2026):
  - **Grok Web** (grok.com / SuperGrok): Search, high-level planning, brainstorming, context generation.
  - **Grok Build** (local CLI on UM690): Grounded execution, code changes with Plan Mode + diffs, subagents, cluster orchestration, long-running agentic work.
- **Human-in-the-loop is mandatory**. There is no automatic shared memory between Grok Web and Grok Build. The user explicitly exports context from Grok Web into Nextcloud, then invokes Grok Build with clear instructions that reference those Nextcloud artifacts.
- **Browser-centric control UI**. The M93p Firefox session is the driver seat. Everything is accessed via pinned tabs, bookmarks, Dashboard widgets, and a web terminal.
- **Local-first where possible**. Ollama + parllama TUI + Vector DB handle sensitive/RAG work. Grok Build is used when its agentic depth is required.
- **Privacy mitigations without sacrificing capability**. Strict `.gitignore` + Grok Build config toggles are applied; full Grok web connectivity is retained.

This model is more robust and sovereign than embedding agentic tools inside Obsidian because storage, versioning, multi-user access, and search are handled by Nextcloud itself.

---

## 2. High-Level Architecture

### 2.1 Roles Across the Mesh
- **M93p Tiny (Thin Client / UI Surface)**: Runs Ubuntu Server 26.04 minimal + Firefox (locked down via policies.json + userChrome.css). Boots into a maximized Firefox window focused on Nextcloud. Provides the browser-centric control UI.
- **UM690 (Control Plane / AIDE_OS Host)**: Runs Nextcloud, Ollama, n8n, Grok Build CLI, and AIDE_OS orchestration layer. This is where all real work happens.
- **Worker M93p nodes**: Orchestrated by Grok Build / AIDE_OS scripts when needed. Results surface back in Nextcloud for review in the browser.

### 2.2 Software Stack (Focused on Grok Integration)
**Browser Surface (M93p)**:
- Firefox with strong enterprise policies (`policies.json`) to lock settings and menus.
- Extensions for productivity: Sidebery (or Tree Style Tab) for vertical tabs/sidebars, tiling/window management extensions.
- Pinned tabs / bookmarks for: Nextcloud Text, Talk, Dashboard, AI surfaces, Grok Web, Web Terminal (to UM690), n8n.

**Backend (UM690)**:
- Nextcloud (source of truth + shared memory).
- Ollama + **parllama** (CLI TUI for model management and container guardrails).
- Vector DB (Qdrant / pgvector / Milvus) + n8n for semantic RAG over Nextcloud files.
- **Grok Build CLI** (installed and configured for headless + interactive use).
- AIDE_OS layer (personas, secure invocation scripts, session handling).

**Integration Mechanisms**:
- Nextcloud folders act as the persistent bridge between Grok Web and Grok Build.
- Web terminal (ttyd or similar) inside Firefox for interactive Grok Build sessions.
- n8n flows for headless `grok -p "..."` invocations triggered from Nextcloud.
- Future: ACP (Agent Client Protocol) bridge for deeper embedding if desired.

---

## 3. Core Feature: Complementary Grok Web + Grok Build Workflow

This is the heart of the design and the primary AI capability of AIDE_OS.

### 3.1 Role Definitions (Official Capabilities)

**Grok Web (SuperGrok / grok.com)**:
- Strengths: Open-ended search, architectural planning, brainstorming, synthesizing context, generating high-quality prompts and decision documents.
- Runs in a pinned tab inside the Firefox session on the M93p.
- Limitation: No direct access to local files or the cluster.

**Grok Build (local CLI on UM690)**:
- Strengths: Full filesystem and git access, Plan Mode with clean diffs, parallel subagents, skills via AGENTS.md + MCP, terminal execution, cluster orchestration, headless mode.
- Official installation: `curl -fsSL https://x.ai/cli/install.sh | bash` then `grok login`.
- Key modes: Interactive TUI, headless (`grok -p "prompt"`), session resumption (`--session-id` / `--resume`), ACP for embedding.

### 3.2 Human-in-the-Loop Handoff Process (Critical)

Because there is **no automatic shared memory** between Grok Web and Grok Build, the following explicit process is required:

1. Work in the **Grok Web** pinned tab (planning, research, context generation).
2. Explicitly export the important outputs (plans, decisions, context summaries, prompts) into a Nextcloud Text note or dedicated folder (e.g., `/AI Contexts/` or `/AIDE_OS/Sessions/`).
3. Review the exported artifact.
4. Invoke **Grok Build** (via web terminal tab or n8n) with clear instructions that reference the Nextcloud context file + the actual project paths on the UM690.
5. Grok Build executes on the UM690, writes results/diffs back into Nextcloud-visible paths.
6. Review results in the Nextcloud interface inside Firefox and iterate.

**Success depends on**:
- Consistent use of Nextcloud as the versioned, searchable shared memory.
- Clear, explicit instructions written by the human.
- Templates and checklists stored in Nextcloud (part of AIDE_OS self-documentation).

### 3.3 Privacy Mitigations for Grok Build

Grok Build uploads the full tracked repository + git history by default for deep context. Mitigations (must be applied):
- Strict `.gitignore` for sensitive paths (homelab secrets, credentials, private family data).
- Configuration toggles in `~/.grok/config.toml` (or environment variables) to control what is sent.
- Prefer running Grok Build against carefully curated project directories rather than the entire home directory.
- Log and review sessions when working on infrastructure.

Full Grok web connectivity is retained.

### 3.4 Integration into AIDE_OS

AIDE_OS on the UM690 becomes the orchestration layer that:
- Manages Grok Build configuration, personas, and session handling.
- Provides secure invocation scripts (limited user, audited).
- Writes structured outputs back into Nextcloud folders.
- Coordinates with Ollama/parllama for local-first tasks.
- Surfaces status and results to the Firefox control UI.

The M93p Firefox session is the primary interface through which the human directs AIDE_OS and the Grok tools.

**References** (as of July 2026):
- Grok Build overview & installation: https://x.ai/cli and https://docs.x.ai/build/overview
- Headless mode, session management, ACP: Official Grok Build documentation
- Privacy behavior and mitigation options: Documented in Grok Build configuration guidance
- SuperGrok tier: https://x.ai (unlocks full Grok Build access)

---

## 4. Supporting Components

### 4.1 Nextcloud Enhancements (to replace Obsidian)
- **Nextcloud Collectives** for structured knowledge linking.
- Vector database (Qdrant preferred) + n8n indexing pipeline for true semantic RAG over files and notes.
- Text app + custom Dashboard widgets.
- Versioning and search as first-class features.

### 4.2 Local AI Layer (Phase 2)
- Ollama on UM690.
- **parllama** (or equivalent CLI TUI) for model management, quantization, and container guardrails.
- Open WebUI or Nextcloud-compatible chat surface exposed as a pinned tab.
- Vector RAG via n8n + Vector DB so local models can answer questions about the vault.

### 4.3 Browser Surface (M93p)
- Firefox locked down with `policies.json` (settings, menus, downloads, extensions controlled).
- `userChrome.css` + Sidebery for a clean, productive layout (vertical tabs + sidebars).
- Maximized window managed by the display server (ubuntu-frame recommended for Ubuntu 26.04).
- No reliance on the strict `--kiosk` flag or native PWA support (both create functional conflicts with advanced workflows).

---

## 5. Phased Implementation Plan

### Phase 1: Foundation (Nextcloud + Firefox Browser Surface)
- M93p boots into a usable, locked-down Firefox session focused on Nextcloud.
- Pinned tabs/bookmarks established for core surfaces (Text, Talk, Dashboard, Web Terminal, Grok Web).
- Basic AIDE_OS theming applied.
- Success: Stable browser-centric control UI ready for AI workflows.

### Phase 2: Local-First AI + Enhanced PKM
- Deploy Ollama + parllama TUI on UM690.
- Integrate chat/RAG surfaces into the Firefox session.
- Add Nextcloud Collectives + Vector DB + n8n pipeline.
- Success: Local AI feels native and Obsidian-level linking/RAG is available without external tools.

### Phase 3: Deep Grok Build Integration
- Install and harden Grok Build on UM690 (config, .gitignore, limited user).
- Create AIDE_OS scripts and n8n flows for reliable invocation.
- Document and practice the human-in-the-loop handoff process.
- Optional: Explore ACP-based deeper embedding.
- Success: Grok Web planning + Grok Build execution feels like a seamless, browser-orchestrated workflow across the mesh, with Nextcloud as reliable shared memory.

---

## 6. Open Questions / Future Refinements
- Exact Firefox extension set and `userChrome.css` for the cleanest productive layout.
- Preferred Vector DB and n8n indexing pattern for Nextcloud files.
- Degree of ACP integration desired in Phase 3 vs. keeping the workflow explicit and auditable.
- Resource allocation guidance for concurrent Ollama + Grok Build + Nextcloud on the UM690.

---

**Summary**: This design prioritizes a clean, explicit, human-orchestrated integration of Grok Web and Grok Build inside a Nextcloud-centric browser environment. The M93p provides the control UI; the UM690 provides the power. Nextcloud serves as the durable shared memory that makes the complementary strengths of the two Grok tools reliable and sovereign. Obsidian is fully eliminated.
