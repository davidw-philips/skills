# Multi-Agent Skills Hub

A unified collection of token-efficient agent skills designed for **GitHub Copilot**, **Claude Code**, **OpenAI Codex**, and **Universal Agents**.

Most skills pair an LLM with a dedicated, lightweight CLI tool built exclusively on the Python standard library, querying a remote MCP endpoint on demand — eliminating the overhead of configuring local MCP JSON files and dumping full tool schemas into agent context upfront. **cgraph** is the exception: it wraps [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph), a self-contained Node-based CLI that runs a *local* MCP server to index and query a codebase's structure — no cloud dependency, no API key.

---

## Included Skills & Repositories

| Skill | Upstream Repository | Description | Authentication |
|---|---|---|---|
| **awskb** | [davidw-philips/awskb](https://github.com/davidw-philips/awskb) | Official AWS Knowledge MCP CLI & Agent Skill. Searches AWS documentation, Code Samples, Regional Availability, and Pricing. | Public (No key required) |
| **cexa** | [davidw-philips/cexa](https://github.com/davidw-philips/cexa) | Exa Neural Search CLI & Agent Skill. Direct interface to Exa MCP for semantic search, web scraping, and domain filtering. | `EXA_API_KEY` |
| **firebridge** | [davidw-philips/firebridge](https://github.com/davidw-philips/firebridge) | Firecrawl MCP CLI & Agent Skill. Scrape dynamic pages to clean markdown, web search, crawl domains, and map sitemaps. | `FIRECRAWL_API_KEY` |
| **ctxseven** | [davidw-philips/ctxseven](https://github.com/davidw-philips/ctxseven) | Context7 documentation CLI & Agent Skill. Resolves library IDs and retrieves current, version-specific documentation and examples. | `CONTEXT7_API_KEY` |
| **deepwiki** | [davidw-philips/deepwiki](https://github.com/davidw-philips/deepwiki) | DeepWiki repository documentation CLI & Agent Skill. Query public GitHub repository architecture, design, and code organization through indexed documentation. | Public (No key required) |
| **cgraph** | [davidw-philips/cgraph](https://github.com/davidw-philips/cgraph) | CodeGraph Agent Skill. Wraps `codegraph`, a local, auto-syncing code knowledge graph — answers structural questions ("how does X work", "what calls Y") from a pre-built index via a single MCP tool, `codegraph_explore`, with zero file reads. | Public (No key required, 100% local) |

---

## Fast Install (One-Liners)

You can install skills directly without cloning the repository by executing the installer scripts from GitHub:

### PowerShell (Windows & Cross-Platform)

Raw Script URL: `https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.ps1`

```powershell
# Install all skills globally into your user profile:
irm https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.ps1 | iex

# To pass a different scope or target, download then invoke the scriptblock:
$installer = irm https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.ps1
& ([scriptblock]::Create($installer)) -Scope cwd -Targets copilot, claude

# Example: install Codex skills globally:
& ([scriptblock]::Create($installer)) -Scope global -Targets codex
```

The direct command uses the installer defaults: `global all`.

---

### Bash / Zsh (Linux & macOS)

Raw Script URL: `https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh`

```bash
# Install all skills globally (~/.copilot/skills, ~/.claude/skills, etc.):
curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- global all

# Install all skills into current workspace (cwd):
curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- cwd all

# Install specific skills locally (e.g. Copilot and Claude only):
curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- cwd copilot claude
```

---

## Directory Structure

```text
skills/
├── .github/skills/        # GitHub Copilot skills (.github/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   ├── deepwiki/
│   └── cgraph/
├── .claude/skills/        # Claude Code skills (.claude/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   ├── deepwiki/
│   └── cgraph/
├── .codex/skills/         # OpenAI Codex skills (.codex/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   ├── deepwiki/
│   └── cgraph/
├── .agents/skills/        # Universal Agent skills (.agents/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   ├── deepwiki/
│   └── cgraph/
├── install-skills.sh      # Bash installer script
├── install-skills.ps1     # PowerShell installer script
└── README.md
```

---

## CLI Tools Installation (Prerequisite)

Install the underlying Python CLI tools:

```bash
# With uv (recommended)
uv tool install git+https://github.com/davidw-philips/awskb.git
uv tool install git+https://github.com/davidw-philips/cexa.git
uv tool install git+https://github.com/davidw-philips/firebridge.git
uv tool install git+https://github.com/davidw-philips/ctxseven.git
uv tool install git+https://github.com/davidw-philips/deepwiki.git

# Or with pipx
pipx install git+https://github.com/davidw-philips/awskb.git
pipx install git+https://github.com/davidw-philips/cexa.git
pipx install git+https://github.com/davidw-philips/firebridge.git
pipx install git+https://github.com/davidw-philips/ctxseven.git
pipx install git+https://github.com/davidw-philips/deepwiki.git
```

### cgraph (codegraph) — different install path

`cgraph` is not a Python package. It wraps [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph), a self-contained CLI with its own bundled runtime (no Node.js required):

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Windows (PowerShell)
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex

codegraph install   # wire into detected agents
codegraph init       # build the graph for the current project
```

See [davidw-philips/cgraph](https://github.com/davidw-philips/cgraph) for the full guide, including the optional Node.js installer scripts bundled in each `cgraph` skill folder's `scripts/` (needed only for the npm install path or library embedding, not the standard CLI/MCP install above).

## Environment Variables

### API Keys

```bash
export EXA_API_KEY="your-exa-key"
export FIRECRAWL_API_KEY="your-firecrawl-key"
export CONTEXT7_API_KEY="your-context7-key"
```

`awskb`, `deepwiki`, and `cgraph` need no API key — `awskb` and `deepwiki` query public, unauthenticated endpoints, and `cgraph` runs entirely locally with no remote endpoint at all.

### Custom TLS/SSL Configuration

All tools using remote MCP endpoints (`awskb`, `cexa`, `firebridge`, `ctxseven`) support custom TLS certificate bundles via environment variables. This is useful when operating behind corporate proxies or with custom CA certificates.

```bash
# Set one or both for custom TLS verification
export SSL_CERT_FILE="/path/to/ca-bundle.crt"    # Path to a CA certificate bundle
export SSL_CERT_DIR="/etc/ssl/certs"             # Path to directory with CA certificates
```

Each tool will automatically use these variables if set. If TLS verification fails and these are not configured, the error message will suggest setting them. `cgraph` has no remote endpoint, so TLS configuration doesn't apply to it; see [davidw-philips/cgraph](https://github.com/davidw-philips/cgraph) for its own `CODEGRAPH_*` environment variables.

**Tools with TLS support:**
- `awskb` — Supports `SSL_CERT_FILE`, `SSL_CERT_DIR`
- `cexa` — Supports `SSL_CERT_FILE`, `SSL_CERT_DIR`
- `firebridge` — Supports `SSL_CERT_FILE`, `SSL_CERT_DIR`
- `ctxseven` — Supports `SSL_CERT_FILE`, `SSL_CERT_DIR`
- `deepwiki` — Public endpoint, no TLS configuration needed
```

---

## Local Usage (Cloned Repo)

If you have cloned the repository locally:

```bash
# Bash
./install-skills.sh <cwd|global> <target...>

# PowerShell
.\install-skills.ps1 <cwd|global> <target...>
```

### Scope & Target Reference

| Argument | Value | Description |
|---|---|---|
| **Scope** | `cwd` | Installs into the current directory (`./.<target>/skills/`) |
| | `global` | Installs into user profile directory (`~/.<target>/skills/` or Windows user profile) |
| **Targets** | `copilot` | GitHub Copilot (`.github/skills` or `~/.copilot/skills`) |
| | `claude` | Claude Code (`.claude/skills` or `~/.claude/skills`) |
| | `codex` | OpenAI Codex (`.codex/skills` or `~/.codex/skills`) |
| | `agents` | Universal Agents (`.agents/skills` or `~/.agents/skills`) |
| | `all` | Installs all four agent target directories |
