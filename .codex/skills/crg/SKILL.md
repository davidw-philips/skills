---
type: skill
name: code-review-graph-cli
category: code-review
description: Teach agents how to review PRs and changes efficiently using code-review-graph CLI, minimizing tokens while maximizing context.
prerequisites:
  - code-review-graph installed (pip/pipx)
  - Project graph built (code-review-graph build)
  - git repository with branches
targets:
  - claude-code
  - cursor
  - copilot
---

# Code Review Graph CLI Skill

Teach AI agents how to use code-review-graph for token-efficient code reviews—analyzing changes, assessing risk, and understanding impact across branches and worktrees.

## What is Code Review Graph?

code-review-graph builds a **persistent, token-efficient graph** that maps:
- 📍 **Changed symbols**: Functions/classes modified in current review
- 📊 **Impact radius**: What else depends on changes
- ⚠️ **Risk scores**: Confidence in safety of changes
- 💰 **Token savings**: 82x compression vs. full codebase dump
- 🎯 **Test coverage**: Which tests cover changed code

Saves massive tokens compared to AI reading entire codebase.

## Key Concepts

### Database Per Worktree
```
my-project/
├─ .code-review-graph/graph.db          (main)
├─ .git-worktrees/
│  ├─ feature-1/.code-review-graph/graph.db  (separate)
│  └─ feature-2/.code-review-graph/graph.db  (separate)
```

Auto-detected and independent.

### Branch Switching
Within **same worktree**, same database with auto-sync on switch:
```bash
git checkout main       # Uses .code-review-graph/graph.db
git checkout feature    # Same database, syncs if needed
```

## Core Commands

### Build/Update Graph
```bash
code-review-graph build                  # Full index
code-review-graph build --incremental    # Only changed files
code-review-graph build --embeddings     # Add semantic search
```

**When to use:**
- First time setup
- After pulling latest changes
- Before major review

### Review PR
```bash
code-review-graph review-pr #123
# Returns: Changed functions + impact + risk + test coverage
```

**When to use:**
- Reviewing a GitHub PR
- "Is this PR safe?"
- Pre-merge analysis

### Review Branch Delta
```bash
code-review-graph review-delta main..feature-branch
# Returns: What changed from main to feature
```

**When to use:**
- Local branches
- "Show me what changed"
- "What's the blast radius?"

### Search Symbols
```bash
code-review-graph search "PaymentProcessor"
# Returns: Ranked matches + usage locations
```

**When to use:**
- "Where is X defined?"
- "Find all uses of X"
- Spot checks

### Query Graph
```bash
code-review-graph query "What calls authenticate()?"
# Returns: Call chain + dependencies
```

**When to use:**
- "How does this work?"
- "What depends on X?"
- Complex dependency questions

### Check Status
```bash
code-review-graph status
# Output:
#   📍 Worktree: main
#   📍 Branch: feature-oauth
#   📊 Symbols: 15,393
#   🔄 Last build: 2 hours ago
#   💾 Database: .code-review-graph/graph.db (125 MB)
```

## Review Workflows

### Workflow 1: GitHub PR Review

```
1. User: "Review PR #123 for risks"
   → Agent runs: code-review-graph review-pr 123
   → Returns: Changed functions + impact + risk scores

2. User: "Which tests cover the changes?"
   → Agent runs: code-review-graph search "test_payment"
   → Returns: Test files that touch PaymentProcessor

3. User: "What else will break?"
   → Agent shows: Impact analysis from review output
   → (Already calculated, no extra query needed)
```

### Workflow 2: Local Branch Review

```
1. User: "Review my feature branch"
   → Agent runs: code-review-graph review-delta main..feature-auth
   → Returns: Full delta analysis

2. User: "Is it safe to merge?"
   → Agent shows: Risk assessment + affected areas
```

### Workflow 3: Pre-Commit Analysis

```
1. User: "I'm about to commit. Check it."
   → Agent runs: code-review-graph review-delta HEAD~1
   → Returns: Quick safety check

2. User: "Commit!"
   → (Safe, merged with confidence)
```

## Token Efficiency Example

**Without code-review-graph:**
- AI reads entire Flask repo (~2000 files)
- 143,594 tokens just to understand the codebase
- PR context: 50,000+ tokens

**With code-review-graph:**
- Graph pre-indexed once
- PR context: ~250 tokens (compressed change + impact)
- **82x token savings**

## Worktree Handling

Automatic per-worktree databases:

```bash
# Main worktree
code-review-graph build

# Feature worktree (auto-detected)
git worktree add .git-worktrees/feature-1
cd .git-worktrees/feature-1
code-review-graph build  # Creates separate .code-review-graph/graph.db
```

No manual setup—auto-detected.

## Branch Handling

Same worktree, multiple branches:

```bash
git checkout main
code-review-graph review-delta HEAD~1  # Review latest main commit

git checkout feature
code-review-graph review-delta main..feature  # Compare to main
```

Graph automatically updates when switching.

## Search Types

### Exact Symbol Search
```bash
code-review-graph search "authenticate"
# Returns exact matches ranked by relevance
```

**Use when:** You know the exact symbol name

### Semantic Search (with embeddings)
```bash
code-review-graph build --embeddings
code-review-graph search --semantic "password validation logic"
# Returns semantically similar code
```

**Use when:** 
- You need "code like this" matching
- Exact name not known
- Exploring unfamiliar codebase

### Hybrid Search (default)
Combines exact matching + semantic (if available) + graph traversal.

## When to Use Each Command

| Question | Command | Needs Build? |
|----------|---------|------------|
| "Review PR #123" | `review-pr 123` | Yes |
| "Diff main..feature" | `review-delta main..feature` | Yes |
| "Find X" | `search X` | Yes |
| "How does X work?" | `query "describe X"` | Yes |
| "What's changed?" | `review-delta HEAD~1` | Yes |
| "Status" | `status` | No |

## Agent Decision Making

**When user says "Review this":**
1. Check if graph built → `code-review-graph status`
2. If not: `code-review-graph build` (one-time cost)
3. Run: `code-review-graph review-pr` OR `code-review-graph review-delta`
4. Return: Compressed, risk-scored results

**When user says "Is this safe?":**
1. Run: `code-review-graph review-delta` (current branch vs target)
2. Return: Risk score + affected areas

**For multi-worktree work:**
1. Each worktree has independent database
2. Auto-detected, no special handling
3. Can review different worktrees in parallel

## Performance Notes

- **First build:** 30 seconds - 5 minutes (depends on repo size)
- **Incremental update:** <1 second (only changed files)
- **Search:** Instant (FTS5 indexed)
- **Semantic search:** ~100ms per query (with embeddings)

Token savings are **permanent** — graph reuse across all reviews.

