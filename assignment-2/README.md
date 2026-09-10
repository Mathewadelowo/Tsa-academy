# Dockerized Diagnostic CLI

A lightweight Alpine-based container image providing a unified command-line diagnostic tool.

## Image Features
- **Base Image**: `alpine:3.19`
- **User**: Non-root `appuser` (UID 1000, GID 1001) for runtime security.
- **Package Additions**: `bash`, `iputils` (for `ping`), `netcat-openbsd` (for `nc`), and `ca-certificates`.

## Building the Image

To build the Docker image locally, run the following command from your project root:

```bash
docker build -t diagnostic-cli .
```

## Commands Supported

### Help Menu
Display the available commands and usage instructions:
```bash
docker run --rm diagnostic-cli help
```

### System Information
Collect core system metrics (hostname, current user, uptime, CPU, memory, and OS data):
```bash
docker run --rm diagnostic-cli system
```

### Disk Check
Evaluate the disk usage of a path against a specific percentage threshold (e.g., 80%):
```bash
docker run --rm diagnostic-cli disk 80 /
```

### Network Diagnostics
Check host connectivity, perform ping tests, or verify open TCP ports:
```bash
# Basic host ping check
docker run --rm diagnostic-cli network google.com

# Target a specific TCP port
docker run --rm diagnostic-cli network google.com 443
```

## Persistent Logging
By default, the container destroys runtime logs when it exits due to the `--rm` flag. To save the diagnostic logs directly to your local machine's `logs/` directory, mount a local volume:

```bash
docker run --rm -v \$(pwd)/logs:/app/logs diagnostic-cli system
```
