#!/bin/bash
export USERID=$(id -u)
export PATH="$PATH:/usr/local/bin"
export GROUPID=$(id -g)
cd $(dirname $0)
[ $BRANCH_NAME == "master" ] && export NEXUS_REPO=snapshot || export NEXUS_REPO=snapshot
docker-compose -f test-bed.yml run --rm -w "$WORKSPACE" --name maven-${BUILD_NUMBER} -e NEXUS_REPO=$NEXUS_REPO --entrypoint "SBI/runtests.sh" node
