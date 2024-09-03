#!/bin/sh
set -eu

set -a
. .ci/lib.sh
set +a

echo Obtaining AWS Public ECR credentials

setAwsEcrCreds "$AWS_CREDS_FILE"

echo Done
