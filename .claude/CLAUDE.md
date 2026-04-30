<!-- @import /home/konrad/.claude/CLAUDE.md -->

# Project-Specific Configuration

This file imports workspace-level configuration from `/home/konrad/.claude/CLAUDE.md`.
All workspace rules apply. Project-specific rules below strengthen or extend them.

The workspace `/home/konrad/.claude/` directory contains additional instruction files
(MERMAID.md, NOTEBOOK.md, DATASCIENCE.md, GIT.md, GITHUB.md, and others) referenced by
CLAUDE.md. Consult workspace CLAUDE.md and the .claude directory to discover all
applicable standards.

## Mandatory Bans (Reinforced)

The following workspace rules are STRICTLY ENFORCED for this project:

- **No automatic git tags** - only create tags when user explicitly requests
- **No automatic version changes** - only modify version in package.json/pyproject.toml/etc. when user explicitly requests
- **No automatic publishing** - never run `make publish`, `npm publish`, `twine upload`, or similar without explicit user request
- **No manual package installs if Makefile exists** - use `make install` or equivalent Makefile targets, not direct `pip install`/`uv install`/`npm install`
- **No automatic git commits or pushes** - only when user explicitly requests

## Project Context

**Copier template** for [stellars-jupyterhub-ds](https://github.com/stellarshenson/stellars-jupyterhub-ds) deployment overlays.

Repository: `stellarshenson/copier-stellars-jupyterhub-ds`

This template scaffolds a thin deployment directory that lives alongside a read-only
clone of the upstream JupyterHub platform. The overlay carries only what changes
between deployments - branding, hostname/TLS, admin user, optional CIFS - so
deployments stay upgradeable.

**Layout**:
```
stellars-jupyterhub-template/
  copier.yml                              # Interview questions and post-copy tasks
  template/                               # Files rendered into the destination
    *.jinja                               # Jinja-rendered files
    {% if ... %}.jinja                    # Conditionally-rendered files/dirs
    branding/                             # Logo, favicon, JupyterLab icon
    certs/                                # Self-signed TLS scripts
  extra/                                  # Standalone helpers shipped outside template/
    certs-installer/                      # OS trust-store cert installers (sh + bat)
  README.md                               # Operator-facing usage documentation
  LICENSE                                 # MIT
```

**Technology Stack**:
- [Copier](https://copier.readthedocs.io/) 9.0+ for templating
- Jinja2 for variable substitution and conditional file rendering
- Bash + Batch scripts for cert generation and OS trust-store installation
- Targets Docker Compose / JupyterHub 4 deployments downstream

**Submodule context**: This repo is checked out as a git submodule of the parent
`local_stellars_jupyterhub_ds` workspace, but has its own remote (`origin` points
to GitHub) and independent commit history. Commits made here do not flow back
to the parent automatically.

## Strengthened Rules

**Copier template hygiene**:
- Variables defined in `copier.yml` MUST match references in `template/**/*.jinja`
- Validators in `copier.yml` use Jinja `regex_search` - test patterns mentally before committing
- `_tasks` run after copy with `--trust` only - keep them idempotent
- Conditional file/directory names use `{% if var %}name{% endif %}` - watch for empty-string traps
- Defaults computed from earlier answers should degrade gracefully when those answers are blank or unusual (e.g. IP addresses vs DNS names)

**Generated artefact awareness**:
- Files under `template/` are NOT executed locally - they are rendered into a destination directory
- Test renders by running `copier copy --trust . /tmp/test-render` against a scratch directory
- Never assume the user has run a render before reporting "done" - inspect the Jinja sources directly

**GitHub project**: This repo is GitHub-hosted, so `.claude/GITHUB.md` workspace rules
apply for badges, link checker config, and naming conventions.

**Modus primaris for README**: User-facing operator documentation must follow
modus primaris - flowing narrative with key facts as bullets, no fluff, explicit
about what `--trust` means and why it is needed.
