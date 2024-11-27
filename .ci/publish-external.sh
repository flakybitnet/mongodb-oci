#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

src_image="$HARBOR_REGISTRY/$APP_NAME/$APP_COMPONENT:$APP_VERSION"
dst_image="$DEST_REGISTRY/$EXTERNAL_REGISTRY_NAMESPACE/$APP_NAME-$APP_COMPONENT:$APP_VERSION"
dst_authfile="$HOME/auth.json"

echo && echo "Setting authentication for $DEST_REGISTRY"
if printf '%s' "$DEST_REGISTRY" | grep -q "ecr.aws"; then
  setRegistryCredHelper "$dst_authfile" "$DEST_REGISTRY" 'ecr-login'
  dst_image="$DEST_REGISTRY/$EXTERNAL_REGISTRY_NAMESPACE/$APP_NAME/$APP_COMPONENT:$APP_VERSION"
else
  setRegistryAuth "$dst_authfile" "$DEST_REGISTRY" "$DEST_CREDS"
fi

echo && echo "Pushing $dst_image"
retry 2 skopeo copy "docker://$src_image" "docker://$dst_image" --dest-authfile="$dst_authfile"

echo && echo 'Done'
