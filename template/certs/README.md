# Cert directory

Self-signed TLS certs for this deployment. Generated on first `./start.sh` run by `certs_generate.sh`, reading `certs.params` for CN and SANs.

## Default behaviour: exact-name SANs (no wildcards)

`certs.params` is rendered with an enumerated SAN list — the exact subdomains the deployment exposes. By default that is:

- `<jupyterhub_subdomain>.<base_hostname>` — configured access URL
- `<base_hostname>` — root host
- `traefik.<base_hostname>` — Traefik dashboard
- `<jupyterhub_subdomain>.localhost` — host-machine access via localhost
- `localhost` — bare localhost
- `traefik.localhost` — host-machine Traefik dashboard

Every name on this list is exact-matched in OpenSSL, curl, browsers, and Python's `ssl` module. Nothing surprises.

## Why no wildcards by default

`*.localhost` is the obvious shortcut, but **OpenSSL 3.x rejects single-label wildcards** — it treats `localhost` like a TLD and refuses to validate the match (same security rule that prevents `*.com`). Browsers and curl behave identically because they're backed by OpenSSL. Test it on any cert:

```bash
openssl x509 -in cert.pem -noout -checkhost hub.localhost
# Hostname hub.localhost does NOT match certificate
```

Multi-label wildcards like `*.lab.example.com` work fine — the rule is "wildcard must be followed by at least two labels".

## How to configure a wildcard cert if you want one

Edit `certs.params`, change `CERTS_DNS_ALTNAMES` to your list, delete the existing prefix folder + `tls.yml`, then re-run:

```bash
rm -rf certs/<old-prefix>/ certs/tls.yml
bash certs/certs_generate.sh
```

### Works: multi-label DNS host wildcard

```bash
CERTS_DNS_ALTNAMES="*.lab.example.com,lab.example.com,localhost"
```

Covers `anything.lab.example.com` plus bare `lab.example.com` and `localhost`. `*.lab.example.com` has two labels (`lab` + `example.com`), so OpenSSL accepts.

### Does NOT work: single-label wildcard

```bash
CERTS_DNS_ALTNAMES="*.localhost,localhost"   # rejected by OpenSSL 3.x
```

Test with `openssl x509 -checkhost hub.localhost` — fails. Same in curl, urllib, and recent Chrome/Firefox.

### Workaround: fake intermediate label

```bash
CERTS_DNS_ALTNAMES="*.app.localhost,app.localhost,localhost"
```

Then access via `https://hub.app.localhost/`, `https://traefik.app.localhost/`, etc. Two labels after the wildcard so OpenSSL is happy. You'd also need to update Traefik routing rules (`compose_override.yml`) and your `JUPYTERHUB_PREFIX` to use `app.localhost` instead of `localhost` directly.

### IPs: no wildcards at all

IP-mode deployments can't use wildcard SANs (RFC 5280 forbids them on iPAddress entries). The default exact list is the only option.

## Verify before deploying

After regenerating the cert, check each hostname you plan to use:

```bash
openssl x509 -in <prefix>/cert.pem -noout -checkhost <hostname>
```

If it says `does match certificate`, you're good. If it says `does NOT match`, OpenSSL won't accept the connection — and neither will most other clients.
