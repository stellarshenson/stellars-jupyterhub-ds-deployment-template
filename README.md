# stellars-jupyterhub-ds Deployment Template
![GitHub Actions](https://github.com/stellarshenson/copier-stellars-jupyterhub-ds/actions/workflows/validate-template.yml/badge.svg)
![JupyterLab 4](https://img.shields.io/badge/JupyterLab-%20%20%20%204%20%20%20%20-orange?style=flat)
[![Brought To You By KOLOMOLO](https://img.shields.io/badge/Brought%20To%20You%20By-KOLOMOLO-00ffff?style=flat)](https://kolomolo.com)
[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-blue?style=flat)](https://www.paypal.com/donate/?hosted_button_id=B4KPBJDLLXTSA)

[Copier](https://copier.readthedocs.io/) template that scaffolds a thin
deployment overlay for [stellars-jupyterhub-ds](https://github.com/stellarshenson/stellars-jupyterhub-ds)
(the upstream JupyterHub platform).

The generated overlay carries only what changes between deployments - branding,
hostname / TLS, admin user, optional CIFS - and clones the upstream platform
read-only so deployments stay upgradeable: pull new upstream commits without
touching your overlay.

## Before you start

You'll need four things on your machine: Docker, Docker Compose, Python, and Copier. Each one has a quick check command — if all four print sensible output, you're ready.

### On Linux

Run the four checks below. Any error means you need to install or fix that piece.

```bash
docker ps                    # should list containers (or print an empty header) — proves Docker is running
docker compose version       # should print "Docker Compose version v2.x.y"
python3 --version            # should print 3.11.x, 3.12.x, or 3.13.x
copier --help                # should print Copier's usage screen
```

If any of those fail, here's how to fix them:

**Docker missing or `docker ps` says permission denied?**

```bash
# Debian / Ubuntu - install Docker, Compose, and containerd in one go
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add yourself to the docker group so you don't need sudo for every command
sudo usermod -aG docker "$USER"
# Log out and back in (or open a new terminal) for the group change to take effect
```

**Python missing?**

```bash
sudo apt install -y python3 python3-pip
```

**Copier missing?**

```bash
pip install --user copier
# If `copier --help` still says "command not found", add ~/.local/bin to PATH:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

### On Windows

The template generates Linux scripts and Linux containers, so the cleanest path on Windows is to do everything inside WSL2 (Microsoft's official Linux-on-Windows). Four steps:

1. **Enable the WSL feature in Windows.** Open **Control Panel → Programs → Turn Windows features on or off**, tick **Windows Subsystem for Linux** (and **Virtual Machine Platform** while you're there), click OK, and reboot.
2. **Install WSL2 and Ubuntu.** Open PowerShell as Administrator and run `wsl --install`, then reboot again. You'll have an Ubuntu shell when it's done.
3. **Install Docker Desktop** from <https://www.docker.com/products/docker-desktop/>. After installing, open it once and go to **Settings → Resources → WSL Integration** and turn it on for your Ubuntu distro.
4. **Open your Ubuntu (WSL2) terminal** and follow the Linux steps above. The four check commands should work the same way as on native Linux.

If `docker ps` errors inside WSL2 with something about the daemon, double-check that Docker Desktop is running and that WSL Integration is enabled for the distro you're in.

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
  certs/                               # Self-signed TLS generator + rendered certs.params
  compose_override.yml                 # Branding env vars + Traefik wiring
  compose_cifs.yml                     # Optional CIFS NAS mount (only if cifs_shared_mount=true)
  env.default                          # Default env (tracked)
  .env                                 # Local overrides (gitignored; takes precedence over env.default)
  start.sh / stop.sh                   # First start.sh auto-generates a self-signed cert from certs/certs.params
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
