# certs-installer

Cross-platform installers that add a self-signed certificate to the
operating system's root trust store, so browsers no longer warn about
the deployment's TLS certificate.

These are operator-side helpers that ship alongside the copier
template but are not copied into generated deployments. Run them
against the certificate produced by `certs/certs_generate.sh` inside
your generated deployment.

## Usage

```bash
# Linux / macOS
./extra/certs-installer/install_cert.sh /path/to/cert.pem

# Windows (Command Prompt or PowerShell)
extra\certs-installer\install_cert.bat C:\path\to\cert.pem
```
