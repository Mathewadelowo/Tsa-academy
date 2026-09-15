# DevOps Tool 

A small Bash-based diagnostics utility, packaged with Docker and validated by a
three-stage GitHub Actions pipeline (lint → test → docker).

## Repository Layout

```
.
├── .github/
│   └── workflows/
│       └── ci.yml
└── assignment-3/
    ├── app/
    │   └── app.sh
    ├── scripts/
    │   ├── lint.sh
    │   └── build.sh
    ├── tests/
    │   └── test.sh
    ├── Dockerfile
    └── docker-compose.yml
```

The GitHub Actions workflow is stored at the repository root under
`.github/workflows/` so that GitHub can discover it. Workflows placed anywhere
else are ignored.

## Requirements

- Bash 4+
- Docker (and the Compose v2 plugin, for the Compose section)
- Standard GNU/Linux userland utilities

## Application Usage

Run the application from the repository root.

### Help

```bash
bash assignment-3/app/app.sh help
```

### System information

```bash
bash assignment-3/app/app.sh system-info
```

Displays hostname, uptime, architecture, kernel, CPU usage, and memory usage.

### Check a host

```bash
bash assignment-3/app/app.sh check-host example.com
```

Attempts to resolve the supplied hostname.

### Check a TCP port

```bash
bash assignment-3/app/app.sh check-port example.com 443
```

Validates the port number and checks TCP connectivity.

### Exit codes

| Code | Meaning                      |
| ---- | ---------------------------- |
| 0    | Successful operation         |
| 1    | Operational/runtime failure  |
| 2    | Invalid command or input     |

## Local Validation

### Linting

```bash
bash assignment-3/scripts/lint.sh
```

The lint script:

- checks that required project files exist
- syntax-checks the Bash scripts with `bash -n`

Expected output:

```
Linting passed.
```

### Tests

```bash
bash assignment-3/tests/test.sh
```

The test suite covers:

1. `help`
2. system information
3. invalid command
4. missing host
5. valid host
6. missing `check-port` arguments
7. missing port
8. non-numeric port
9. port `0`
10. port `65536`

Expected output:

```
Tests passed: 10
Tests failed: 0
```

## Docker

Build the image:

```bash
docker build -t devops-tool assignment-3/
```

Run the help command:

```bash
docker run --rm devops-tool help
```

Run the system information command:

```bash
docker run --rm devops-tool system-info
```

The application runs in the container as a non-root user.

### Build and smoke tests

The build script automates the Docker build and smoke tests:

```bash
bash assignment-3/scripts/build.sh
```

It checks that:

- the Docker image builds successfully
- `help` runs successfully
- `system-info` runs successfully
- an invalid command returns exit code `2`

### Docker Compose

The project includes a minimal Compose configuration. From inside
`assignment-3/`:

```bash
docker compose up --build
```

The Compose configuration builds the application image from the local
Dockerfile.

## CI/CD Pipeline

The workflow lives at `.github/workflows/ci.yml` and runs on pushes and pull
requests.

```
validate
   ↓
test
   ↓
docker
```

### 1. Validate

```bash
bash assignment-3/scripts/lint.sh
```

Checks the required files and Bash syntax.

### 2. Test

```bash
bash assignment-3/tests/test.sh
```

Executes the application test suite. Declared with `needs: validate`.

### 3. Docker

```bash
bash assignment-3/scripts/build.sh
```

Declared with `needs: test`, so Docker validation does not run if linting or
tests fail.

## CI Failure Demonstration

A deliberate failure was introduced to verify the pipeline detects problems:

1. Introduce an intentional error into the project.
2. Commit and push the change.
3. GitHub Actions detected the failure and marked the workflow red.
4. Inspect the failed job and identify the cause.
5. Correct the error.
6. Commit and push the fix.
7. GitHub Actions reran the pipeline.
8. The final workflow completed successfully with all jobs green.

Final pipeline state:

```
validate  ✅
   ↓
test      ✅
   ↓
docker    ✅
```

This confirms the workflow can both detect failures and verify fixes.

## Development Workflow

The project was developed using a feature branch workflow:

```
feature
   ↓
local testing
   ↓
commit
   ↓
merge into main
   ↓
push main
   ↓
GitHub Actions
```

The feature branch was used for development and testing. Changes were merged
into `main`, and only `main` was pushed to GitHub.

## Final Verification

Before submission, run:

```bash
bash assignment-3/scripts/lint.sh
bash assignment-3/tests/test.sh
bash assignment-3/scripts/build.sh
```

All three should complete successfully, and GitHub Actions should show all
three jobs green:

```
validate  ✅
test      ✅
docker    ✅
```
