# Rancher Pipeline Images

This repository contains the Dockerfiles for the images for automation pipelines and to build
the images that are used by the GitHub Action runners

## Images

There are multiple images that are developed and maintained in this repository.

### GitHub Action Runner

- `rancher-docker-release.artifactory.dhl.com/rancher-pipeline/gha-runner-ubuntu-20.04`
  for Ubuntu 20.04 based images
- `rancher-docker-release.artifactory.dhl.com/rancher-pipeline/gha-runner-ubuntu-22.04`
  for Ubuntu 22.04 based images

The image that is used by the GitHub Action runners provided by the Kubernetes
and the Open Source Platform team for the runners managed by them.

The image comes in two variants - one based on Ubuntu 20.04 and one based on
Ubuntu 22.04. The images are enriched with a set of tools that may be useful for
various automation tasks and workflows. These tools are as follows:

- `kubectl`
- `kustomize`
- `helm` and `helm diff`
- `jq`
- `yq`
- `twistcli`
- `docker` and `buildx`
- `terraform`
- `gh` (GitHub CLI)
- `yamllint`

The specific versions of the tools are defined in the `Dockerfile` and are kept
up to date using Renovate and automated pull requests.

### Rancher Pipeline Ansible Image

- `rancher-docker-release.artifactory.dhl.com/rancher-pipeline/ansible`

Image contains Python, Ansible as well as some additional CLI tools. A list of the 
tools can be found in the Dockerfile. These images are not meant as replacements 
for the GitHub Action runner images, but can instead be used Ansible commands as 
part of GitHub Actions workflows.

## Image Tags

Images are released by pushed to the `main` branch of this repository and
trigger a build and push of the images to the registry. The following tags are used:

- `latest` - the latest version of the image, only available in the production
  registry
- `sha-<sha>` - the image with the specific git commit SHA

Additionally, the CI/CD pipeline for this repository also triggers a build on
Pull Requests and pushes those images. The set of tags for those images is as follows:

- `sha-<sha>` - the image with the specific git commit SHA
- `pr-<pr-number>` - the image built for a specific pull request, only available

## Dependency Management

Dependency updates are managed by Renovate. Renovate is configured to open a PR
against the `main` branch whenever a new version of a dependency is available.
This will trigger a build of the image with the new version of the dependency.
If the build succeeds and the new version is compatible with the automation
pipelines and our infrastructure, the PR can be merged.
