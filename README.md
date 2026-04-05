# Golang Pipeline

A reusable GitHub Actions pipeline for Go services. Handles verification, building, publishing, and deploying to GKE across isolated, dev, UAT, and production environments.

## Usage

Create `.github/workflows/pipeline.yml` in your Go service repo:
```yaml
name: CI/CD Pipeline

on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize, closed]
  push:
    branches:
      - main

jobs:
  pipeline:
    uses: mpandouris/platform/.github/workflows/golang-pipeline.yml@stable
    with:
      service_name: your-service-name
      go_version: '1.21'
    secrets: inherit
```

That's it.

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `service_name` | ✅ | — | Name of your service. Used for image name, deployment name, and namespace. |
| `go_version` | ❌ | `1.21` | Go version to use for verification and build. |

## Secrets

These secrets must be set in your GitHub repo under **Settings → Secrets → Actions**. They are inherited automatically by the pipeline — no need to pass them explicitly.

| Secret | Description |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub password |
| `GKE_CLUSTER` | GKE cluster name |
| `GKE_ZONE` | GKE cluster zone|
| `GKE_WORKLOAD_PROVIDER` | Workload Identity Federation provider |
| `GKE_SA` | GCP service account email |

## Pipeline stages

### Pull request opened or updated
Verify → Build → Publish → Deploy isolated *(manual approval)*

### Push to main
Verify → Build → Publish → Deploy DEV *(manual approval)* → Deploy UAT *(manual approval)* → Deploy Production *(manual approval)*

## Environments

The pipeline uses four GitHub environments, each requiring manual approval before deploying. Create these in **Settings → Environments** in your repo:

| Environment | Triggered by | Purpose |
|---|---|---|
| `dev` | Push to main | First environment after merge |
| `uat` | After DEV approved | User acceptance testing |
| `production` | After UAT approved | Live environment |

## Image tagging

| Event | Tag |
|---|---|
| Push to main | Commit SHA + `latest` |

Images are published to Docker Hub as `DOCKER_USERNAME/service_name:tag`.

## K8s manifests

The pipeline deploys using plain `kubectl` — no Helm required. Your service repo must have a `deploy/k8s/` folder containing your manifests:
```shell
deploy/
└── k8s/
├── deployment.yaml
├── service.yaml
```

The deployment name in your manifests must match `service_name`.

## Updating the pipeline

The pipeline is versioned via a moving `stable` tag. When a new version is released, the tag is moved automatically — all services pick up the update with no changes required on their end.

If you need to pin to a specific version, replace `@stable` with a commit SHA:
```yaml
uses: mpandouris/platform/.github/workflows/golang-pipeline.yml@abc1234
```