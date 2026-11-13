# Agent instructions

## Public repo: no real identifiers

This repository is public, and so is everything built from it: npm packages, release files, PR and issue text. A name that lands in a commit stays in git history and in every published package, and removing it later takes a history rewrite, npm unpublishes and GitHub Support. Keep real-world identifiers out of everything you write here.

- **Never write** the developer's employer or its domain, GitHub org or repo names, Slack or Linear workspace URLs, cloud project, service, registry or deploy-label names, customer names, colleagues' GitHub logins, work email addresses, real machine hostnames, or absolute home paths. This covers code, defaults, tests, fixtures, docs, screenshots, commit messages, PR titles and descriptions, review replies and issues.
- **Use fictional stand-ins:** org `example`, repo `example/app`, project `acme`, host `dev-box`, email `alice@example.com`, path `/home/user`. Ticket keys such as `ABC-123` and first names on their own are fine.
- **Machine-specific values live on the machine.** Which services to watch, who reviews, local paths: read them from local settings. Never ship them as defaults in the code.
- **Output from real data stays local.** Logs, sample results and screenshots from a run on the developer's real setup don't go into a commit or PR as-is. Describe them, or swap every real value for a fictional one first.
- **Commit only source.** Never commit symlinks, `node_modules`, or anything that points into the local machine. Before every commit, read `git diff --cached` for absolute paths and real names.
- **Found one already in the repo?** Fix it in a commit whose message doesn't quote the value (for example "replace a real name with a fictional one"), and tell the developer so they can decide whether history and npm need cleaning too.
