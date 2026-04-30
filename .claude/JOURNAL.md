# Claude Code Journal

This journal tracks substantive work on documents, diagrams, and documentation content.

---

1. **Task - Release v1.0.3** (v1.0.3): bump patch version<br>
    **Result**: incremented 1.0.2 -> 1.0.3, committed, tagged v1.0.3, pushed branch and tag to origin. Version source of truth aligned with the existing v1.0.2 git tag before this release; `pyproject.toml` is the single place the template version lives (no Python runtime, just metadata: name, version, description, authors, homepage). The workspace's no-automatic-git policy was waived for this single `/release` invocation per the command's documented umbrella approval.
