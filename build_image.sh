#!/bin/sh
set -e

usage () {
    echo "Usage:" >&2
    echo "  $1 -t DOCKER_IMAGE_NAME [ -c COMMIT ]" >&2
    echo >&2
    echo " Options:" >&2
    echo "  -t                  Docker image name. Example: registry/group/repo:tag" >&2
    echo "  -c                  Commit hash, branch name or commit tag. Default: locally checked out commit, tag or branch" >&2
}

while getopts 't:c:' opt; do
    case "$opt" in
        t) 
            DOCKER_IMAGE_NAME="$OPTARG"
            ;;
        c) 
            COMMIT="$OPTARG"
            ;;
        \?) 
            echo "Invalid -$OPTARG command option.">&2
            usage $0
            exit 1
            ;;
        :) 
            echo "Missing argument -$OPTARG">&2
            usage $0
            exit 1
            ;;
        *) 
            usage $0
            exit 1
            ;;
    esac
done

if [ "$OPTIND" -le "$#" ]; then
    echo "Invalid argument at index '$OPTIND' does not have a corresponding option." >&2
    usage $0
    exit 1
fi

if [ -z "$DOCKER_IMAGE_NAME" ]; then
    echo "Docker image name must be defined." >&2
    usage $0
    exit 1
fi

if [ -z "$COMMIT" ]; then
    COMMIT=$(git rev-parse --short HEAD)
fi

# get other build env var values
VENDOR=LNLS
AUTHOR=$(git show -q --format='%an <%ae>')
BUILD_DATE=$(date -I)
REPOSITORY_URL=$(git remote show origin |grep Fetch|awk '{ print $3 }')
REPOSITORY=`basename $REPOSITORY_URL | sed "s/.git//"`

# build docker image
docker build --no-cache -t ${DOCKER_IMAGE_NAME} \
	--build-arg VENDOR="$VENDOR" \
	--build-arg AUTHOR="$AUTHOR" \
	--build-arg BUILD_DATE="$BUILD_DATE" \
	--build-arg REPOSITORY_URL="$REPOSITORY_URL" \
	--build-arg REPOSITORY="$REPOSITORY" \
	--build-arg COMMIT="$COMMIT" \
        .
