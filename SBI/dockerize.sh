#!/bin/bash
set -x
export PATH="$PATH:/usr/local/bin"
DIR=$(dirname $0)
source $DIR/lib/function.sh
case $BRANCH_NAME in
  qa)
   if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
    tag=$BRANCH_NAME-$(version)-$BUILD_ID
    dockerfile=Dockerfile.develop
    fi
    ;;
  develop)
  if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
    tag=$BRANCH_NAME-$(version)-$BUILD_ID
    dockerfile=Dockerfile.develop
    fi
    ;;
  master)
  if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
   tag=$BRANCH_NAME-$(version)-$BUILD_ID
   dockerfile=Dockerfile.prod
   fi
    ;;
  *)
  echo $BRANCH_NAME
    tag=$BRANCH_NAME-$(version)-$BUILD_ID
    dockerfile=Dockerfile.develop
esac

services=$(cat $(dirname $0)/service-manifest.txt)
for s in $services
do
docker build -t ${s}:${tag}  -f $(dirname $0)/docker/$dockerfile .
done
