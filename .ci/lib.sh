#!/bin/sh
set -eu

export CI_ENV_FILE='.ci/env'
if [ -f "$CI_ENV_FILE" ]; then
    . "$CI_ENV_FILE"
fi


# $1 - retries count
retry () {
    retries="$1"
    shift

    count=0
    wait=5
    until "$@"; do
        exit=$?
        wait=$((wait * 2))
        count=$((count + 1))
        if [ $count -lt "$retries" ]; then
            echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
            sleep $wait
        else
            echo "Retry $count/$retries exited $exit, no more retries left."
            return $exit
        fi
    done

    unset retries count wait
    return 0
}

getAppVersion () {
    app_version=$(printf '%s' "$CI_COMMIT_SHA" | head -c 8)
    if [ -n "${CI_MANUAL_TAG-}" ]; then
        app_version="$CI_MANUAL_TAG"
    elif [ -n "${CI_COMMIT_TAG-}" ]; then
        app_version="$CI_COMMIT_TAG"
    fi

    printf '%s' "$app_version"
    unset app_version
}

getAppRelease () {
    release=false
    if [ -n "${CI_MANUAL_TAG-}" ]; then
        release=true
    elif [ -n "${CI_COMMIT_TAG-}" ]; then
        release=true
    fi

    printf '%s' "$release"
    unset release
}

# $1 - configuration file
# $2 - registry
# $3 - registry creds in form of 'user:pass'
setRegistryAuth () {
    auth=$(printf '%s' "$3" | base64 -w 0)
    auths=$(printf '{"auths":{"%s":{"auth":"%s"}}}' "$2" "$auth")
    printf '%s' "$auths" > "$1"

    unset auth auths
}

# AWS_ACCESS_KEY_ID - login
# AWS_SECRET_ACCESS_KEY - password
# $1 - file with token
setAwsEcrCreds () {
    password=$(aws ecr-public get-login-password --region us-east-1)
    printf '%s:%s' "AWS" "$password" > "$1"

    unset password
}
