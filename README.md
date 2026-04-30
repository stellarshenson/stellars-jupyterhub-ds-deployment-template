# stellars-jupyterhub-ds Deployment Template
![GitHub Actions](https://github.com/stellarshenson/copier-stellars-jupyterhub-ds/actions/workflows/validate-template.yml/badge.svg)
![JupyterLab 4](https://img.shields.io/badge/JupyterLab-%20%20%20%204%20%20%20%20-orange?style=flat)
[![Brought To You By KOLOMOLO](https://img.shields.io/badge/Brought%20To%20You%20By-KOLOMOLO-00ffff?style=flat)](https://kolomolo.com)
[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-blue?style=flat)](https://www.paypal.com/donate/?hosted_button_id=B4KPBJDLLXTSA)

Source: [stellarshenson/copier-stellars-jupyterhub-ds](https://github.com/stellarshenson/copier-stellars-jupyterhub-ds)

[Copier](https://copier.readthedocs.io/) template that scaffolds a thin
deployment overlay for [stellars-jupyterhub-ds](https://github.com/stellarshenson/stellars-jupyterhub-ds)
(the upstream JupyterHub platform).

The generated overlay carries only what changes between deployments - branding,
hostname / TLS, admin user, optional CIFS - and clones the upstream platform
read-only so deployments stay upgradeable: pull new upstream commits without
touching your overlay.

## Quickstart

```bash
pip install copier
copier copy --trust gh:stellarshenson/copier-stellars-jupyterhub-ds ./my-jupyterhub
cd my-jupyterhub
./start.sh
```

`--trust` lets copier run the template's `_tasks` (chmod on the generated `start.sh` / `stop.sh`); without it copier refuses to execute post-copy commands.

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
  start.sh / stop.sh
  stellars-jupyterhub-ds/              # Upstream platform (cloned read-only on first start)
```

## Updating from this template

Pull newer revisions of this template into an existing overlay:

```bash
copier update --trust                  # re-render against the latest template at gh:stellarshenson/copier-stellars-jupyterhub-ds
```

`--trust` is required again because `copier update` re-runs the template's `_tasks`.

Copier persists answers in `.copier-answers.yml` so subsequent updates pick
up new template features without re-asking the same questions. Conflicting
edits surface as merge prompts.

This is independent from upstream platform updates: `copier update` refreshes
the overlay from this template repo, while `start.sh --refresh` (in the
generated overlay) pulls new commits for the upstream `stellars-jupyterhub-ds`
clone.

## What stays in the upstream platform

The `stellars-jupyterhub-ds/` directory is treated as **read-only**: every
overlay-specific change belongs in this generated directory, not upstream.
Bug fixes and feature work for the platform itself live in the
[upstream repo](https://github.com/stellarshenson/stellars-jupyterhub-ds).

## License

[MIT](LICENSE) - same as the upstream platform.
