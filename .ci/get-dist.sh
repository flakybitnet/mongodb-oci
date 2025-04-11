#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

echo && echo 'Updating and installing required system packages and dependencies'
apt update
apt install -y wget

mkdir dist
cd dist

echo && echo "Downloading MongoDB ${MONGO_BINARIES_VERSION}"
wget "https://dist.flakybit.net/mongodb/mongodb-${MONGO_BINARIES_VERSION}-linux-amd64-debian-12.tar.gz"
wget "https://dist.flakybit.net/mongodb/mongodb-${MONGO_BINARIES_VERSION}-linux-amd64-debian-12.tar.gz.sha256"
sha256sum -c "mongodb-${MONGO_BINARIES_VERSION}-linux-amd64-debian-12.tar.gz.sha256"

echo && echo "Downloading MongoDB tools ${MONGO_TOOLS_VERSION}"
wget "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-x86_64-${MONGO_TOOLS_VERSION}.tgz"

echo && echo "Downloading MongoDB rust-ping ${MONGO_RUST_PING_VERSION}"
wget "https://github.com/syndikat7/mongodb-rust-ping/releases/download/v${MONGO_RUST_PING_VERSION}/mongodb-rust-ping-x86_64-unknown-linux-gnu.tar.gz"

echo && echo "Downloading MongoDB shell ${MONGO_SHELL_VERSION}"
wget "https://downloads.bitnami.com/files/stacksmith/mongodb-shell-${MONGO_SHELL_VERSION}-linux-amd64-debian-12.tar.gz"
wget "https://downloads.bitnami.com/files/stacksmith/mongodb-shell-${MONGO_SHELL_VERSION}-linux-amd64-debian-12.tar.gz.sha256"
sha256sum -c "mongodb-shell-${MONGO_SHELL_VERSION}-linux-amd64-debian-12.tar.gz.sha256"

echo && echo "Downloading yq ${YQ_VERSION}"
wget "https://downloads.bitnami.com/files/stacksmith/yq-${YQ_VERSION}-linux-amd64-debian-12.tar.gz"
wget "https://downloads.bitnami.com/files/stacksmith/yq-${YQ_VERSION}-linux-amd64-debian-12.tar.gz.sha256"
sha256sum -c "yq-${YQ_VERSION}-linux-amd64-debian-12.tar.gz.sha256"

echo && echo "Downloading wait-for-port ${WAIT_PORT_VERSION}"
wget "https://downloads.bitnami.com/files/stacksmith/wait-for-port-${WAIT_PORT_VERSION}-linux-amd64-debian-12.tar.gz"
wget "https://downloads.bitnami.com/files/stacksmith/wait-for-port-${WAIT_PORT_VERSION}-linux-amd64-debian-12.tar.gz.sha256"
sha256sum -c "wait-for-port-${WAIT_PORT_VERSION}-linux-amd64-debian-12.tar.gz.sha256"

echo && echo "Downloading render-template ${RENDER_TEMPLATE_VERSION}"
wget "https://downloads.bitnami.com/files/stacksmith/render-template-${RENDER_TEMPLATE_VERSION}-linux-amd64-debian-12.tar.gz"
wget "https://downloads.bitnami.com/files/stacksmith/render-template-${RENDER_TEMPLATE_VERSION}-linux-amd64-debian-12.tar.gz.sha256"
sha256sum -c "render-template-${RENDER_TEMPLATE_VERSION}-linux-amd64-debian-12.tar.gz.sha256"

echo && echo 'Done'

