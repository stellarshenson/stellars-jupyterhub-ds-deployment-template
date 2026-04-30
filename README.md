# stellars-jupyterhub-ds Deployment Template

[Copier](https://copier.readthedocs.io/) template that scaffolds a thin
deployment overlay for [stellars-jupyterhub-ds](https://github.com/stellarshenson/stellars-jupyterhub-ds).

The generated overlay carries only what changes between deployments — branding,
hostname / TLS, admin user, optional CIFS — and clones the upstream platform
read-only so deployments stay upgradeable: pull new upstream commits without
touching your overlay.

## Quickstart

```bash
pip install copier
copier copy gh:stellarshenson/stellars-jupyterhub-ds-deployment-template ./my-jupyterhub
cd my-jupyterhub
./start.sh
```

The interview asks ~15 questions (project name, hostname, admin user, branding
prefix, optional CIFS / local TLS / etc.) and renders a working deployment.
Each default is computed from earlier answers where possible.

## Generated layout

```
my-jupyterhub/
  branding/                            # Logo, favicon, JupyterLab toolbar icon
  certs/                               # Self-signed TLS scripts (if local TLS)
  compose_override.yml                 # Branding env vars + Traefik wiring
  compose_cifs.yml                     # Optional CIFS NAS mount
  .env.default                         # Default env (tracked)
  .env                                 # Local overrides (gitignored)
  start.sh / stop.sh / cleanup.sh
  stellars-jupyterhub-ds/              # Upstream platform (cloned read-only on first start)
```

## Updating from upstream

```bash
copier update                          # re-render with the latest template + your saved answers
```

Copier persists answers in `.copier-answers.yml` so subsequent updates pick
up new template features without re-asking the same questions. Conflicting
edits surface as merge prompts.

## What stays in the upstream platform

The `stellars-jupyterhub-ds/` directory is treated as **read-only**: every
overlay-specific change belongs in this generated directory, not upstream.
Bug fixes and feature work for the platform itself live in the
[upstream repo](https://github.com/stellarshenson/stellars-jupyterhub-ds).

## License

Same as the upstream platform.
