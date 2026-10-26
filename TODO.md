# Project Submission: Minecraft Server 2

Complete every item on this checklist before submitting the project. If you have
added any extras, briefly mention them so the mentors can review them if needed.

## Table of contents

- [1. Repository](#1-repository)
  - [Required files](#required-files)
  - [Dockerfile](#dockerfile)
  - [Docker Compose](#docker-compose)
  - [README](#readme)
- [2. Documentation](#2-documentation)
- [3. Notes](#3-notes)
  - [General notes](#general-notes)
  - [Security](#security)
  - [Code conventions](#code-conventions)
  - [Testing](#testing)

## 1. Repository

### Required files

- [ ] Add a `.gitignore` file that excludes irrelevant content from the Git repository.
- [ ] Add a `docker-compose.yaml` file that meets the requirements below.
- [ ] Add a `README.md` file that meets the requirements below.
- [ ] Ensure that every other file in the repository is explicitly named and described in the README.

### Dockerfile

- [ ] Add a `Dockerfile` that builds a suitable image for running a Minecraft server. See [Notes](#3-notes) for the server download link.
- [ ] Install and, where necessary, configure all required packages in the base image.
- [ ] Ensure that the server can start reliably; provide default values for environment variables where appropriate.
- [ ] Do not use a prebuilt Minecraft image.

### Docker Compose

- [ ] Define and configure a service named `mc-server`.
- [ ] Configure all non-sensitive Minecraft server environment variables for the service. Do not include credentials.
- [ ] Publish the required ports so the container can be reached from the internet.
- [ ] Configure volumes to persist container data on the filesystem so that the game world is not lost.

### README

- [ ] Include a table of contents.
- [ ] Include a repository description that explains its purpose and main contents.
- [ ] Include a **Quickstart** section with the prerequisites and brief startup instructions.
- [ ] Include a **Usage** section with detailed configuration instructions, including how to modify relevant settings to achieve different results.

## 2. Documentation

Document the code and project in a `README.md` file in the repository. All project
documentation and related materials must be in English.

## 3. Notes

Download the Minecraft Java Edition server from the [official Minecraft server
download page](https://www.minecraft.net/en-us/download/server).

### General notes

- [ ] In addition to your GitHub repository, record and provide a short Loom video (no longer than 5 minutes) introducing your submission and showing the relevant steps you completed. You do not need to explain every detail.

### Security

- [ ] Do not store SSH keys in the Git repository workspace.
- [ ] Do not store passwords, tokens, or usernames in code. Use environment variables instead.
- [ ] Do not store IP addresses or other sensitive information in the Git repository.

### Code conventions

- [ ] Use `UPPER_CASE_WITH_UNDERSCORES` for build arguments, environment variables, and shell variables.
- [ ] Use brace notation when referencing variables to avoid ambiguous interpretation: `${SOME_VAR_VALUE}`, not `$SOME_VAR_VALUE`.
- [ ] Set default values for build arguments and environment variables when appropriate.
- [ ] Keep sensitive configuration, such as tokens and passwords, out of the repository. Provide it to the container using an `.env` file or another suitable method.

### Testing

Before submitting the project, verify the following:

- [ ] The Minecraft server is reachable at your cloud VM's IP address on port `8888`.
- [ ] Test the connection either by launching the game and connecting to the server or by using a script. The [mcstatus Python module](https://github.com/py-mine/mcstatus) can be used for script-based checks.
- [ ] (Optional) Connect to the server on your cloud VM and play using the Java Edition Minecraft client on your computer.
- [ ] After a server restart, configured data—including the game world and game server configuration—remains available and is not deleted or overwritten.
- [ ] Service containers restart when an error causes them to terminate.
