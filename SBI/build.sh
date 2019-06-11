#!/bin/bash

export PATH="$PATH:/usr/local/bin"
export USERID=$(id -u)
export GROUPID=$(id -g)
echo "Running as UID=$USERID, GID=$GROUPID on branch $BRANCH_NAME"
cd $(dirname $0)
docker-compose -f test-bed.yml run --name node-${BUILD_NUMBER} --rm -w "$WORKSPACE"  --entrypoint "npm install" node
