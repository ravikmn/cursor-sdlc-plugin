# cursor-sdlc-plugin

A Cursor plugin that runs the full software development lifecycle (SDLC) — requirements, design, coding, testing, review, release and maintenance — using agents, subagents, skills, rules, commands and hooks, connected to **GitHub** through MCP.

Built for **Python** projects and tuned to keep token usage low.

> Cursor's plugin format is new. Check field names against the [Cursor plugin docs](https://cursor.com/docs/reference/plugins) before publishing.

## How it works

The `sdlc-orchestrator` agent takes a GitHub issue and hands it through a chain of stage subagents:

| Stage | Agent | Output |
|---|---|---|
| 1. Requirements | `requirements-analyst` | Spec with Given/When/Then acceptance criteria (`docs/specs/<issue>.md`) — needs your approval |
| 2. Design | `solution-designer` | One-page design note (`docs/design/<issue>.md`) — approval needed if >3 files or any schema/API change |
| 3. Code | `implementer` | Commits on `feature/<issue>-<slug>` or `fix/<issue>-<slug>` |
| 4. Test | `test-engineer` | Passing tests mapped to each acceptance criterion |
| 5. Review | `code-reviewer` | BLOCKER / MAJOR / MINOR findings (max 2 fix loops) |
| 6. Release | `release-manager` | GitHub pull request + CI status |

The orchestrator never writes code itself, passes only IDs and file paths between stages, and stops to ask you if a stage fails twice. Nothing is merged to `main` without your explicit approval.

## Layout

```
.cursor-plugin/plugin.json      # plugin manifest
mcp.json                        # GitHub MCP server
agents/
  sdlc-orchestrator.md
  requirements-analyst.md
  solution-designer.md
  implementer.md
  test-engineer.md
  code-reviewer.md
  release-manager.md
skills/
  write-spec/SKILL.md
  write-design-note/SKILL.md
  github-pr/SKILL.md
  run-tests/SKILL.md
  run-tests/run_tests.sh
  triage-bug/SKILL.md
  templates/spec.md
  templates/design.md
rules/
  coding-standards.mdc          # Python standards (Ruff, mypy, pytest)
  github-workflow.mdc           # branch, commit and PR conventions
commands/
  ship-feature.md
  fix-bug.md
  review-pr.md
hooks/
  hooks.json
  format.sh                     # ruff format + fix after each edit
  block-dangerous.sh            # blocks force-push and direct push to main
```

## Commands

| Command | What it does |
|---|---|
| `/ship-feature <issue>` | Takes a GitHub issue from spec to pull request |
| `/fix-bug <issue>` | Triages a bug (issue or failed CI run), then fixes, tests and opens a PR |
| `/review-pr <number>` | Reviews a pull request and posts findings as review comments |

## GitHub connection

**Option A — GitHub's hosted MCP server (OAuth):**

```json
{
  "mcpServers": {
    "github": { "url": "https://api.githubcopilot.com/mcp/" }
  }
}
```

**Option B — local server with a personal access token** (copy `mcp.token.example.json` over `mcp.json`):

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}" }
    }
  }
}
```

Use a fine-grained token with Contents, Issues, Pull requests and Actions (read) access. Keep it in an environment variable — never commit it.

## Python standards

- Python 3.11+, PEP 8, Ruff for lint and format
- Type hints on public functions; must pass mypy
- pytest in `tests/`, mirroring the package layout
- Inputs validated at boundaries (e.g. Pydantic); no bare `except`
- Dependencies pinned in `pyproject.toml`
- Every bug fix ships with a regression test
- `code-reviewer` runs `pip-audit` for vulnerable dependencies

## Token-saving design

- Agent and skill descriptions are one line; full instructions load only when used.
- Templates live in separate files and are read on demand.
- `run_tests.sh` trims output to a short summary and failures.
- The orchestrator passes issue IDs, file paths and branch names between stages — not the full conversation.

## Install in your team marketplace

1. Add this repo (`ravikmn/cursor-sdlc-plugin`) as a team marketplace in Cursor's team/admin settings. If it later holds several plugins, add `.cursor-plugin/marketplace.json` at the root listing each one.
2. Install the plugin.
3. Sign in with OAuth (Option A) or set `GITHUB_TOKEN` (Option B).
4. Try it: run `/ship-feature` on a small issue.

## Status

v1.0.0 — all plugin files are in place. Next: test it in Cursor on a small issue and adjust field names to Cursor's current plugin schema if needed.
