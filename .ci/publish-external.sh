#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

src_image="$HARBOR_REGISTRY/$APP_NAME/$APP_COMPONENT:$APP_VERSION"
dst_image="$DEST_REGISTRY/$EXTERNAL_REGISTRY_NAMESPACE/$APP_NAME-$APP_COMPONENT:$APP_VERSION"

if printf '%s' "$DEST_REGISTRY" | grep -q "ecr.aws"; then
  dst_image="$DEST_REGISTRY/$EXTERNAL_REGISTRY_NAMESPACE/$APP_NAME/$APP_COMPONENT:$APP_VERSION"
  DEST_CREDS=$(cat "$AWS_CREDS_FILE")
fi

echo "Pushing $dst_image"
retry 2 skopeo copy --dest-creds="$DEST_CREDS" "docker://$src_image" "docker://$dst_image"

echo 'Done'
