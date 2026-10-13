# Multi-Agent Skills Hub

A unified collection of zero-dependency, token-efficient agent skills designed for **GitHub Copilot**, **Claude Code**, **OpenAI Codex**, and **Universal Agents**.

Each skill pairs an LLM with a dedicated, lightweight CLI tool built exclusively on the Python standard library, eliminating heavy MCP (Model Context Protocol) server overhead, subprocess bloat, and external dependencies.

---

## Included Skills & Repositories

| Skill | Repository | Description | Authentication |
|---|---|---|---|
| **awskb** | [davidw-philips/awskb](https://github.com/davidw-philips/awskb) | Official AWS Knowledge MCP CLI & Agent Skill. Searches AWS documentation, Code Samples, Regional Availability, and Pricing. | Public (No key required) |
| **cexa** | [davidw-philips/cexa](https://github.com/davidw-philips/cexa) | Exa Neural Search CLI & Agent Skill. Direct interface to Exa MCP for semantic search, web scraping, and domain filtering. | `EXA_API_KEY` |
| **firebridge** | [davidw-philips/firebridge](https://github.com/davidw-philips/firebridge) | Firecrawl MCP CLI & Agent Skill. Scrape dynamic pages to clean markdown, web search, crawl domains, and map sitemaps. | `FIRECRAWL_API_KEY` |

---

## Directory Structure

```text
skills/
├── .github/skills/        # GitHub Copilot skills
│   ├── awskb/
│   ├── cexa/
│   └── firebridge/
├── .claude/skills/        # Claude Code skills
│   ├── awskb/
│   ├── cexa/
│   └── firebridge/
├── .codex/skills/         # OpenAI Codex skills
│   ├── awskb/
│   ├── cexa/
│   └── firebridge/
├── .agents/skills/        # Universal Agent skills
│   ├── awskb/
│   ├── cexa/
│   └── firebridge/
├── install-skills.sh      # Bash installer (Linux / macOS)
├── install-skills.ps1     # PowerShell installer (Windows)
└── README.md
```

---

## Installation

You can install skills either **locally** to the current working directory (`cwd`) or **globally** to your user profile directory (`global`).

### Prerequisites

Install the underlying zero-dependency Python CLI utilities:

```bash
# Using uv (recommended)
uv tool install git+https://github.com/davidw-philips/awskb.git
uv tool install git+https://github.com/davidw-philips/cexa.git
uv tool install git+https://github.com/davidw-philips/firebridge.git

# Or with pipx
pipx install git+https://github.com/davidw-philips/awskb.git
pipx install git+https://github.com/davidw-philips/cexa.git
pipx install git+https://github.com/davidw-philips/firebridge.git
```

Set the relevant API keys in your environment:

```bash
export EXA_API_KEY="your-exa-key"
export FIRECRAWL_API_KEY="your-firecrawl-key"
```

---

### Bash (`install-skills.sh`)

Syntax:
```bash
./install-skills.sh <cwd|global> <target...>
```

Supported targets: `copilot`, `claude`, `codex`, `agents`, or `all`.

#### Local Installation (Current Repository / Workspace)
```bash
# Install all skills into .github/, .claude/, .codex/, and .agents/ of current workspace:
./install-skills.sh cwd all

# Or install only specific agent targets:
./install-skills.sh cwd copilot claude
```

#### Global Installation (User Profile)
```bash
# Install all skills globally (~/.copilot/skills, ~/.claude/skills, ~/.codex/skills, ~/.agents/skills):
./install-skills.sh global all

# Install globally for GitHub Copilot only:
./install-skills.sh global copilot
```

---

### PowerShell (`install-skills.ps1`)

Syntax:
```powershell
.\install-skills.ps1 <cwd|global> <target...>
```

#### Local Installation (Current Repository / Workspace)
```powershell
# Install all skills into current workspace:
.\install-skills.ps1 cwd all

# Install specific agent skills:
.\install-skills.ps1 cwd copilot claude
```

#### Global Installation (User Profile)
```powershell
# Install all skills globally into user profile:
.\install-skills.ps1 global all

# Install globally for Copilot and Codex:
.\install-skills.ps1 global copilot codex
```

---

## Target Paths Reference

| Agent Target | Local Scope (`cwd`) | Global Scope (`global`) |
|---|---|---|
| `copilot` | `<cwd>/.github/skills/` | `~/.copilot/skills/` |
| `claude` | `<cwd>/.claude/skills/` | `~/.claude/skills/` |
| `codex` | `<cwd>/.codex/skills/` | `~/.codex/skills/` |
| `agents` | `<cwd>/.agents/skills/` | `~/.agents/skills/` |
