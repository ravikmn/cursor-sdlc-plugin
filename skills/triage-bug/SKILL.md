---
name: triage-bug
description: Triage a bug from a GitHub issue or a failed Actions run. Find the likely root cause and a fix plan.
---
1. Fetch the issue or the failed job log with the github MCP.
2. Reproduce the bug locally if you can. Find the suspect commit with git log or blame.
3. Output: severity, root cause, affected files, fix plan, and a regression test to add.
4. Add the labels bug and severity:<level> on the issue.
