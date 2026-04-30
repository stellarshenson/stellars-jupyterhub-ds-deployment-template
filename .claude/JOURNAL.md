# Claude Code Journal

This journal tracks substantive work on documents, diagrams, and documentation content.

---

1. **Task - Release v1.0.3** (v1.0.3): bump patch version<br>
    **Result**: incremented 1.0.2 -> 1.0.3, committed, tagged v1.0.3, pushed branch and tag to origin. Version source of truth aligned with the existing v1.0.2 git tag before this release; `pyproject.toml` is the single place the template version lives (no Python runtime, just metadata: name, version, description, authors, homepage). The workspace's no-automatic-git policy was waived for this single `/release` invocation per the command's documented umbrella approval.

2. **Task - Rename remote and release v1.0.4** (v1.0.4): bundled remote rename + patch bump<br>
    **Result**: GitHub repository was renamed from `stellars-jupyterhub-ds-deployment-template` to `copier-stellars-jupyterhub-ds` upstream; updated all internal references to match across `pyproject.toml` (`name` and `Homepage`), `README.md` (Source line, Quickstart `gh:` shortcut, Updating-from-template `gh:` shortcut), `copier.yml` (header comment example), `template/README.md.jinja` (header overlay link, "Update from template" section, References footer), and `.claude/CLAUDE.md` (Repository field). README also restructured in the prior turn: added explicit Source link at the top, disambiguated "upstream" prose so the platform repo (`stellars-jupyterhub-ds`) is no longer confused with the template repo, renamed "Updating from upstream" heading to "Updating from this template", and added a closing paragraph contrasting `copier update` (template remote) against `start.sh --refresh` (platform remote). Bumped patch 1.0.3 -> 1.0.4, committed all changes as a single bundled release per user choice (option 2 of the three offered), tagged v1.0.4, pushed branch and tag to origin. Submodule pointer (`.git` -> `../.git/modules/copier-stellars-jupyterhub-ds`) had already been updated by the user before this work began.
