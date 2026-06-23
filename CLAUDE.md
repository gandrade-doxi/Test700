# Claude Code Project Instructions

@agent.md

Read and follow [`agent.md`](agent.md) before making changes.

Key requirements:

- Treat `/theme` as the production source.
- Use the page-first WordPress architecture documented in `agent.md`.
- Keep homepage layout changes in `theme/page-home.php`.
- Run `./scripts/validate.sh` before completion when the environment supports it.
- If a required validation tool is unavailable, report the warning and continue with the available checks.
- Do not claim WordPress runtime validation occurred unless it was actually performed.

`agent.md` is the canonical, tool-neutral instruction file. If this file and
`agent.md` ever conflict, follow `agent.md`.
