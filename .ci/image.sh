#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

echo && echo "Setting authentication for $HARBOR_REGISTRY"
authfile='/kaniko/.docker/config.json'
setRegistryAuth "$authfile" "$HARBOR_REGISTRY" "$HARBOR_CREDS"

image="$APP_NAME/$APP_COMPONENT:$APP_VERSION"
dockerfile="./Dockerfile"

echo && echo "Building $image image"
executor -c ./ -f "$dockerfile" -d "$HARBOR_REGISTRY/$image" \
    --build-arg MONGO_VERSION="$MONGO_VERSION" \
    --build-arg MONGO_SHELL_VERSION="$MONGO_SHELL_VERSION" \
    --build-arg MONGO_TOOLS_VERSION="$MONGO_TOOLS_VERSION" \
    --build-arg MONGO_RUST_PING_VERSION="$MONGO_RUST_PING_VERSION" \
    --build-arg YQ_VERSION="$YQ_VERSION" \
    --build-arg WAIT_PORT_VERSION="$WAIT_PORT_VERSION" \
    --build-arg RENDER_TEMPLATE_VERSION="$RENDER_TEMPLATE_VERSION"

echo && echo 'Done'
