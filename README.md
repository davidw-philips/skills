# Multi-Agent Skills Hub

A unified collection of zero-dependency, token-efficient agent skills designed for **GitHub Copilot**, **Claude Code**, **OpenAI Codex**, and **Universal Agents**.

Each skill pairs an LLM with a dedicated, lightweight CLI tool built exclusively on the Python standard library, eliminating heavy MCP (Model Context Protocol) server overhead, subprocess bloat, and external dependencies.

---

## Included Skills & Repositories

| Skill | Upstream Repository | Description | Authentication |
|---|---|---|---|
| **awskb** | [davidw-philips/awskb](https://github.com/davidw-philips/awskb) | Official AWS Knowledge MCP CLI & Agent Skill. Searches AWS documentation, Code Samples, Regional Availability, and Pricing. | Public (No key required) |
| **cexa** | [davidw-philips/cexa](https://github.com/davidw-philips/cexa) | Exa Neural Search CLI & Agent Skill. Direct interface to Exa MCP for semantic search, web scraping, and domain filtering. | `EXA_API_KEY` |
| **firebridge** | [davidw-philips/firebridge](https://github.com/davidw-philips/firebridge) | Firecrawl MCP CLI & Agent Skill. Scrape dynamic pages to clean markdown, web search, crawl domains, and map sitemaps. | `FIRECRAWL_API_KEY` |
| **ctxseven** | [davidw-philips/ctxseven](https://github.com/davidw-philips/ctxseven) | Context7 documentation CLI & Agent Skill. Resolves library IDs and retrieves current, version-specific documentation and examples. | `CONTEXT7_API_KEY` |
| **deepwiki** | [davidw-philips/deepwiki](https://github.com/davidw-philips/deepwiki) | DeepWiki repository documentation CLI & Agent Skill. Query public GitHub repository architecture, design, and code organization through indexed documentation. | Public (No key required) |

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
│   └── deepwiki/
├── .claude/skills/        # Claude Code skills (.claude/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   └── deepwiki/
├── .codex/skills/         # OpenAI Codex skills (.codex/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   └── deepwiki/
├── .agents/skills/        # Universal Agent skills (.agents/skills/<skill>/)
│   ├── awskb/
│   ├── cexa/
│   ├── firebridge/
│   ├── ctxseven/
│   └── deepwiki/
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

Set relevant environment variables (deepwiki does not require an API key):

```bash
export EXA_API_KEY="your-exa-key"
export FIRECRAWL_API_KEY="your-firecrawl-key"
export CONTEXT7_API_KEY="your-context7-key"
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
