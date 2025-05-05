#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

echo && echo 'Setting up environment'

app_name='mongodb'
printf 'APP_NAME=%s\n' "$app_name" >> "$CI_ENV_FILE"

app_component='server'
printf 'APP_COMPONENT=%s\n' "$app_component" >> "$CI_ENV_FILE"

printf 'APP_VERSION=%s\n' "$(getAppVersion)" >> "$CI_ENV_FILE"
mongo_version='7.0.19'
printf 'MONGO_VERSION=%s\n' "$mongo_version" >> "$CI_ENV_FILE"
printf 'MONGO_BINARIES_VERSION=%s\n' "$mongo_version-0" >> "$CI_ENV_FILE"
printf 'MONGO_SHELL_VERSION=%s\n' '2.5.0-1' >> "$CI_ENV_FILE"
printf 'MONGO_TOOLS_VERSION=%s\n' '100.12.0' >> "$CI_ENV_FILE"
printf 'MONGO_RUST_PING_VERSION=%s\n' '0.4.0' >> "$CI_ENV_FILE"
printf 'YQ_VERSION=%s\n' '4.45.1-8' >> "$CI_ENV_FILE"
printf 'WAIT_PORT_VERSION=%s\n' '1.0.8-15' >> "$CI_ENV_FILE"
printf 'RENDER_TEMPLATE_VERSION=%s\n' '1.0.7-15' >> "$CI_ENV_FILE"

printf 'HARBOR_REGISTRY=%s\n' 'harbor.flakybit.net' >> "$CI_ENV_FILE"
printf 'EXTERNAL_REGISTRY_NAMESPACE=%s\n' 'flakybitnet' >> "$CI_ENV_FILE"

cat "$CI_ENV_FILE"

echo && echo 'Done'
