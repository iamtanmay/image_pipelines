# syntax=docker/dockerfile:1

# Dockerfile for the ansible image used in the CI/CD pipeline of the Data Lake
# Rancher platform team.
#
# This image contains ansible as well as a collection of different tools used in
# the CI/CD pipelines - e.g. kubectl, helm, jq, yq, kubeseal, rke, helm-diff.
# Each tool is being installed in it's own stage and then copied to the final
# image to keep the image size and number of layers low.

# renovate: datasource=docker depName=library/python
ARG PYTHON_VERSION=3.11.3-slim-bullseye

# renovate: datasource=docker depName=bitnami/kubectl
ARG KUBECTL_VERSION=1.24.14

# renovate: datasource=docker depName=alpine/helm
ARG HELM_VERSION=3.12.0

FROM bitnami/kubectl:${KUBECTL_VERSION} as install-kubectl
FROM alpine/helm:${HELM_VERSION} as install-helm

### base image for all installer-stages
# renovate: datasource=docker depName=curlimages/curl
FROM curlimages/curl:8.00.0 as installer
RUN mkdir -p /tmp/bin
WORKDIR /tmp/build

### jq
FROM installer as install-jq

# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64
mv jq-linux64 /tmp/bin/jq
chmod 755 /tmp/bin/jq
EOF

### yq
FROM installer as install-yq

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.33.3

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64
mv yq_linux_amd64 /tmp/bin/yq
chmod 755 /tmp/bin/yq
EOF

### bat
FROM installer as install-bat

# renovate: datasource=github-releases depName=sharkdp/bat
ARG BAT_VERSION=0.23.0

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar xvf bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz
mv bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat /tmp/bin/bat
chmod 755 /tmp/bin/bat
EOF

### kubeseal
FROM installer as install-kubeseal

# renovate: datasource=github-releases depName=bitnami-labs/sealed-secrets
ARG KUBESEAL_VERSION=0.21.0

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz
tar xvf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz
mv kubeseal /tmp/bin/kubeseal
chmod 755 /tmp/bin/kubeseal
EOF

### rke
FROM installer as install-rke

# renovate: datasource=github-releases depName=rancher/rke
ARG RKE_VERSION=1.3.20

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/rancher/rke/releases/download/v${RKE_VERSION}/rke_linux-amd64
mv rke_linux-amd64 /tmp/bin/rke
chmod 755 /tmp/bin/rke
EOF

### helm-diff
FROM installer as install-helm-diff

# renovate: datasource=github-releases depName=databus23/helm-diff
ARG HELM_DIFF_VERSION=3.8.0

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/databus23/helm-diff/releases/download/v${HELM_DIFF_VERSION}/helm-diff-linux-amd64.tgz
tar xvf helm-diff-linux-amd64.tgz
mv diff /tmp/bin/diff
chmod 755 /tmp/bin/diff
EOF

### conftest
FROM installer as install-conftest

# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=0.42.1

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
tar xvf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
mv conftest /tmp/bin/conftest
chmod 755 /tmp/bin/conftest
EOF

### Ansible
FROM python:${PYTHON_VERSION} as install-ansible
WORKDIR /workspace

# Install pipenv
RUN pip install --no-cache-dir --index-url https://artifactory.dhl.com/api/pypi/pypi/simple pipenv==2023.3.20

# Tell pipenv to create new virtualenv and use artifactory as pypi mirror
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_PYPI_MIRROR=https://artifactory.dhl.com/api/pypi/pypi/simple
ENV PIP_INDEX_URL=https://artifactory.dhl.com/api/pypi/pypi/simple

# Install ansible and all dependencies
COPY ./Pipfile ./Pipfile.lock ./
RUN pipenv sync

### Final image
FROM python:${PYTHON_VERSION} as final
WORKDIR /workspace

# Setup Artifactory and install packages
# hadolint ignore=DL3008
RUN <<EOF
rm /etc/apt/sources.list
{
    echo 'deb https://artifactory.dhl.com/artifactory/debian-remote bullseye main';
    echo 'deb https://artifactory.dhl.com/artifactory/debian-remote bullseye-updates main';
    echo 'deb https://artifactory.dhl.com/artifactory/debian-remote bullseye-backports main contrib';
    echo 'deb https://artifactory.dhl.com/artifactory/debian-security bullseye-security main'
} >> /etc/apt/sources.list
apt-get update
apt-get install -y --no-install-recommends \
    curl \
    rsync \
    openssh-client
apt-get install -y -t bullseye-backports --no-install-recommends \
    git
rm -rf /var/lib/apt/lists/*
EOF

# Add ansible to path
COPY --from=install-ansible /workspace/.venv /workspace/.venv
ENV PATH /workspace/.venv/bin:$PATH

# Add additional tools to path
COPY --from=install-kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin
COPY --from=install-kubeseal /tmp/bin/kubeseal /usr/local/bin
COPY --from=install-rke /tmp/bin/rke /usr/local/bin
COPY --from=install-helm /usr/bin/helm /usr/local/bin
COPY --from=install-helm-diff /tmp/bin/diff /usr/local/share/helm/plugins/helm-diff
COPY --from=install-conftest /tmp/bin/conftest /usr/local/bin
COPY --from=install-jq /tmp/bin/jq /usr/local/bin
COPY --from=install-yq /tmp/bin/yq /usr/local/bin
COPY --from=install-bat /tmp/bin/bat /usr/local/bin

# Set Helm plugin config
ENV HELM_PLUGINS=/usr/local/share/helm/plugins

# Set default entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
