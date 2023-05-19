# syntax=docker/dockerfile:1

# Dockerfile for the GitHub Actions Runner images used in the CI/CD pipelines.
#
# This image is based on the upstream image from summerwind/actions-runner and
# is enriched with some additional tools and configurations, e.g. kubectl, helm,
# jq, yq, buildx, twistcli, etc. Each tool is being installed in it's own stage
# and then copied to the final image to keep the image size and number of layers
# low.

# renovate: datasource=docker depName=actions-runner-controller/actions-runner-controller/actions-runner-dind
ARG BASE_VERSION=v2.304.0-ubuntu-22.04

# renovate: datasource=docker depName=bitnami/kubectl
ARG KUBECTL_VERSION=1.24.14

# renovate: datasource=docker depName=alpine/helm
ARG HELM_VERSION=3.12.0

# renovate: datasource=docker depName=hashicorp/terraform
ARG TERRAFORM_VERSION=1.4.6

FROM bitnami/kubectl:${KUBECTL_VERSION} as install-kubectl
FROM alpine/helm:${HELM_VERSION} as install-helm
FROM hashicorp/terraform:${TERRAFORM_VERSION} as install-terraform

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

### twistlock
FROM installer as install-twistcli

ARG TWISTLOCK_USERNAME
ARG TWISTLOCK_PASSWORD

RUN <<EOF
set -e
curl -L -o /tmp/bin/twistcli -u $TWISTLOCK_USERNAME:$TWISTLOCK_PASSWORD https://twistlock.apps.datalake.dhl.com/api/v1/util/twistcli
chmod 755 /tmp/bin/twistcli
EOF

### buildx
FROM installer as install-buildx

# renovate: datasource=github-releases depName=docker/buildx
ARG BUILDX_VERSION=0.10.4

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64
mv buildx-v${BUILDX_VERSION}.linux-amd64 /tmp/bin/docker-buildx
chmod 755 /tmp/bin/docker-buildx
EOF

### github CLI
FROM installer as install-gh

# renovate: datasource=github-releases depName=cli/cli
ARG GH_VERSION=2.29.0

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz
tar xvf gh_${GH_VERSION}_linux_amd64.tar.gz
mv gh_${GH_VERSION}_linux_amd64/bin/gh /tmp/bin/gh
chmod 755 /tmp/bin/gh
EOF

### kustomize
FROM installer as install-kustomize

# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION=5.0.3

RUN <<EOF
set -e
curl -LO https://artifactory.dhl.com/artifactory/github-generic/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
tar xvf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
mv kustomize /tmp/bin/kustomize
chmod 755 /tmp/bin/kustomize
EOF

### Final image
FROM actions-runner-controller/actions-runner-controller/actions-runner-dind:${BASE_VERSION} as final

# Switch back to root user to install additional tools
USER root

# Install basic set of tools
# hadolint ignore=DL3008
RUN <<EOF
set -e
sed -i 's http://security.ubuntu.com/ubuntu/ https://artifactory.dhl.com/artifactory/ubuntu-debian-remote/ubuntu/ g' /etc/apt/sources.list
sed -i 's http://archive.ubuntu.com/ubuntu/ https://artifactory.dhl.com/artifactory/ubuntu-debian-remote/ubuntu/ g' /etc/apt/sources.list
rm -rf /etc/apt/sources.list.d/*
apt-get update
apt-get install -y --no-install-recommends \
    build-essential \
    dnsutils \
    ftp \
    iproute2 \
    iputils-ping \
    libunwind8 \
    locales \
    netcat \
    openssh-client \
    parallel \
    python3-pip \
    rsync \
    shellcheck \
    telnet \
    time \
    tzdata \
    upx \
    wget \
    yamllint \
    zstd
apt-get clean
ln -sf /usr/bin/python3 /usr/bin/python
ln -sf /usr/bin/pip3 /usr/bin/pip
rm -rf /var/lib/apt/lists/*
EOF

# Add additional tools to path
COPY --from=install-buildx /tmp/bin/docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx
COPY --from=install-kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin
COPY --from=install-kustomize /tmp/bin/kustomize /usr/local/bin
COPY --from=install-helm /usr/bin/helm /usr/local/bin
COPY --from=install-helm-diff /tmp/bin/diff /usr/local/share/helm/plugins/helm-diff
COPY --from=install-jq /tmp/bin/jq /usr/local/bin
COPY --from=install-yq /tmp/bin/yq /usr/local/bin
COPY --from=install-gh /tmp/bin/gh /usr/local/bin
COPY --from=install-twistcli /tmp/bin/twistcli /usr/local/bin
COPY --from=install-terraform /bin/terraform /usr/local/bin

# Set Helm plugin config
ENV HELM_PLUGINS=/usr/local/share/helm/plugins

# Set Terraform config to use Artifactory
ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
COPY config/terraformrc /etc/terraformrc

# Set Python config to use Artifactory
ENV PIP_INDEX_URL="https://artifactory.dhl.com/artifactory/api/pypi/pypi/simple"
ENV PIP_EXTRA_INDEX_URL="https://artifactory.dhl.com/api/pypi/pypi-dhl-local-dev-public/simple"

# Switch back to runner user
USER runner

# Add git.dhl.com ssh keys
RUN <<EOF
set -e
mkdir ~/.ssh
ssh-keyscan git.dhl.com >> ~/.ssh/known_hosts
EOF

# Disable runner auto updating - this will speed up the initialization of runner
# pods. Caution: Once a runner version is outdated, GH will stop scheduling to
# runners of that version after 30 days.
# See <https://github.com/actions/actions-runner-controller/blob/master/docs/using-entrypoint-features.md>
# and <https://github.com/actions/runner/pull/1558>
ENV DISABLE_RUNNER_UPDATE true
