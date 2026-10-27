# Minecraft Server with Docker Compose

This repository runs a Minecraft Java Edition 26.3 server in a Docker container. The image downloads the official server JAR, and Docker Compose provides local configuration, port mapping, persistent world data, and automatic container restarts.

## Table of contents

- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Project structure](#project-structure)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Build the image](#build-the-image)
  - [Run and manage the server](#run-and-manage-the-server)
  - [Persistence and restarts](#persistence-and-restarts)
  - [Testing](#testing)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- Docker with the Compose plugin (Docker Desktop also works).
- Enough available memory for the configured Java heap. The default maximum heap is `4G`.
- Acceptance of the [Minecraft End User License Agreement](https://www.minecraft.net/eula) before setting `EULA=true`.
- A matching Minecraft Java Edition client if you want to join the server in game.

## Quickstart

Run these commands from the repository root in PowerShell:

1. Copy the example environment file:

   ```powershell
   Copy-Item .env.example .env
   ```

2. Read and accept the Minecraft EULA, then set `EULA=true` in your local `.env` file.
3. Build and start the server:

   ```powershell
   docker compose up --build -d
   ```

4. Watch the startup log until the server reports that it is ready:

   ```powershell
   docker compose logs -f mc-server
   ```

   Press `Ctrl+C` to stop following the log; the server continues running.

5. Connect with Minecraft Java Edition to `localhost:8888`. For a VM, connect to `<VM_HOST>:8888` after allowing TCP port `8888` in the VM's firewall and network rules.

The first start creates `data/`, including the world and an active `server.properties` file. Startup can take a little longer while the world is generated.

## Project structure

| Path | Purpose |
| --- | --- |
| `Dockerfile` | Builds the Java runtime image, downloads and verifies the official Minecraft 26.3 server JAR, and defines the container entry point. |
| `entrypoint.sh` | Requires explicit EULA acceptance, initializes the active configuration once, and starts the Java server. |
| `docker-compose.yaml` | Defines the `mc-server` service, environment defaults, port mapping, persistent mounts, and restart policy. |
| `config/server.properties` | Initial server settings copied into `data/server.properties` only if the active file does not exist. |
| `.env.example` | Example of the local Compose environment file; EULA acceptance is disabled by default. |
| `.gitignore` | Keeps local environment files, keys, generated world data, and editor files out of Git. |
| `.dockerignore` | Excludes local data and unrelated files from the Docker build context. |
| `.gitattributes` | Keeps shell scripts in LF format for execution in the Linux container. |
| `.github/workflows/ci.yml` | GitHub Actions workflow that validates Compose, builds the Docker image, and checks a temporary Minecraft server on pushes and pull requests to `main`. |
| `.github/workflows/quality.yml` | GitHub Actions workflow that checks workflow syntax and scans repository files for exposed secrets on pushes and pull requests to `main`. |
| `TODO.md` | Project submission requirements and verification checklist. |
| `README.md` | Setup, operation, and verification instructions for this repository. |

The generated `data/` directory and local `.env` file are ignored by Git. Keep world data and local configuration when updating or recreating the container.

## Usage

### Configuration

Compose reads the following variables from `.env` in the repository root:

| Variable | Default | Effect |
| --- | --- | --- |
| `EULA` | `false` | Must be `true` after accepting the Minecraft EULA; otherwise the container exits. |
| `PORT` | `8888` | TCP port published on the host. The server listens on port `25565` inside the container. |
| `MC_XMS` | `4G` | Initial Java heap size. |
| `MC_XMX` | `4G` | Maximum Java heap size. |

For example, setting `PORT=8889` in `.env` changes the address used by clients to `localhost:8889`. Set `MC_XMS=2G` and `MC_XMX=2G` if the host has less memory available, then recreate the service with `docker compose up -d --force-recreate mc-server`.

Edit `data/server.properties` to change live server settings such as `motd`, `max-players`, `gamemode`, or `difficulty`. Then run `docker compose restart mc-server`. The `config/server.properties` file is an initial template: changing it later does not overwrite an existing `data/server.properties`. To change the template for a new world, edit it before the first start.

Keep `online-mode=true` for player authentication. The default configuration disables RCON. Do not put credentials or private keys in this repository.

### Build the image

To build the image separately from Compose:

```powershell
docker build -t minecraft-server:local .
```

The final `.` is the Docker build context. The `Dockerfile` downloads the JAR from Mojang and verifies its SHA-1 checksum during the build.

### Run and manage the server

```powershell
docker compose up --build -d
docker compose ps
docker compose logs -f mc-server
docker compose restart mc-server
docker compose down
```

Run the commands from the repository root. `docker compose down` stops and removes the container and network; the bind-mounted `data/` directory remains on the host.
Run each command separately; `docker compose logs -f mc-server` keeps showing new log entries until you press `Ctrl+C`.

### Persistence and restarts

Compose mounts `./data` at `/data` in the container. This directory contains the generated world, active server properties, and other server data. The `./config/server.properties` file is mounted read-only as an initial template.

The service uses `restart: unless-stopped`, so Docker restarts it after an unexpected exit while the Docker daemon is running. A normal `docker compose restart mc-server` or container recreation keeps `data/` intact. Back up `data/` before replacing or deleting host files.

To check persistence, change `motd` in `data/server.properties`, restart the service, and verify that the new message and `data/world/level.dat` are still present. Repeat the check after `docker compose up --force-recreate -d mc-server`.

### Testing

The CI workflow validates the Compose file and builds the image on every push and on pull requests to `main`. It then starts the built image and uses `mcstatus` to check for a Minecraft protocol response on host port `8888`. If the check fails, the workflow shows the container logs. It removes the test container after the check. Deployment to a VM is a separate step and is not part of this workflow.

The separate Quality workflow runs `actionlint` and Gitleaks on the same events. Findings fail the workflow, and Gitleaks redacts detected values from the logs. Neither workflow needs deployment secrets.

Check the server locally with the Minecraft Java Edition client at `localhost:8888`, or use the optional [`mcstatus` Python module](https://github.com/py-mine/mcstatus):

```powershell
py -m pip install mcstatus
py -m mcstatus localhost:8888 status
```

For a VM, use `<VM_HOST>:8888` instead of `localhost:8888` and verify that the network permits inbound TCP traffic on port `8888`. Check `docker compose ps` and `docker compose logs mc-server` on the VM if the server does not respond.

You can also test the EULA guard by running the built image without `EULA=true`; it should exit with an instruction to accept the EULA. To verify the restart policy, check that the container returns to a running state after its main process terminates unexpectedly.

## Troubleshooting

- **The container exits immediately:** Confirm that you accepted the Minecraft EULA and set `EULA=true` in `.env`. Check `docker compose logs mc-server` for the exact error.
- **The published port is unavailable:** Change `PORT` in `.env`, recreate the service, and connect using the new host port.
- **Server settings do not change:** Edit `data/server.properties`, then restart `mc-server`. The file in `config/` only initializes a missing active configuration.
- **The server is unreachable from a VM:** Verify that the service is running, Compose publishes the intended port, and inbound TCP port `8888` is allowed by the VM firewall and cloud network rules.
- **A build fails while downloading the JAR:** Check the network connection and retry the build. The source is the [official Minecraft server download](https://www.minecraft.net/en-us/download/server); the Docker build checks the downloaded file's SHA-1 value.
