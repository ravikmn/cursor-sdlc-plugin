---
name: github-pr
description: Create or update a GitHub pull request with the team template.
---
Use the github MCP create_pull_request tool. If the repo has .github/pull_request_template.md, follow it.
Title: <type>(<scope>): <summary> (#<issue>)
Body sections: Summary, Changes, Testing, Spec link, Design link, "Closes #<issue>".
Labels: copy them from the issue, and add "sdlc-bot".
Base: the default branch unless the user says otherwise. Open it as a draft until review passes.
