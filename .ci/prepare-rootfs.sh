#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

mkdir -p rootfs/opt/bitnami/mongodb/bin

echo && echo "Extracting MongoDB binaries"
tar -zxf "dist/mongodb-${MONGO_BINARIES_VERSION}-linux-amd64-debian-12.tar.gz" --no-same-owner -C rootfs/opt/bitnami/mongodb/bin

echo && echo "Extracting MongoDB tools"
tar -zxf "dist/mongodb-database-tools-debian12-x86_64-${MONGO_TOOLS_VERSION}.tgz" --no-same-owner -C rootfs/opt/bitnami/mongodb/bin --strip-components=2 "mongodb-database-tools-debian12-x86_64-${MONGO_TOOLS_VERSION}/bin"

echo && echo "Extracting MongoDB rust-ping"
tar -zxf "dist/mongodb-rust-ping-x86_64-unknown-linux-gnu.tar.gz" --no-same-owner -C rootfs/opt/bitnami/mongodb/bin

echo && echo "Extracting MongoDB shell"
tar -zxf "dist/mongodb-shell-${MONGO_SHELL_VERSION}-linux-amd64-debian-12.tar.gz" --no-same-owner -C rootfs/opt/bitnami --strip-components=2  --wildcards '*/files'

echo && echo "Extracting yq"
tar -zxf "dist/yq-${YQ_VERSION}-linux-amd64-debian-12.tar.gz" --no-same-owner -C rootfs/opt/bitnami --strip-components=2  --wildcards '*/files'

echo && echo "Extracting wait-for-port"
tar -zxf "dist/wait-for-port-${WAIT_PORT_VERSION}-linux-amd64-debian-12.tar.gz" --no-same-owner -C rootfs/opt/bitnami --strip-components=2  --wildcards '*/files'

echo && echo "Extracting render-template"
tar -zxf "dist/render-template-${RENDER_TEMPLATE_VERSION}-linux-amd64-debian-12.tar.gz" --no-same-owner -C rootfs/opt/bitnami --strip-components=2  --wildcards '*/files'

echo && echo 'Done'

