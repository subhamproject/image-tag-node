#!/bin/bash
export PATH="$PATH:/usr/local/bin"
DIR=$(dirname $0)
source $DIR/lib/function.sh
source $DIR/scan.sh

TMP_IMG=$(mktemp)
SCAN_LOG="scan_status.log"
[ -f $LOGFILE ] && cat /dev/null > $LOGFILE
[ -s $SCAN_LOG ] && cat /dev/null > $SCAN_LOG

[ $BRANCH_NAME == "master" ] && tag=$BRANCH_NAME-$(version) || tag=$BRANCH_NAME-$(version)-$BUILD_ID
case $BRANCH_NAME in
  qa)
   if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
    dockerfile=Dockerfile.develop
    fi
    ;;
  develop)
  if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
    dockerfile=Dockerfile.develop
    fi
    ;;
  master)
  if [ -n "$(echo $BRANCH_NAME|grep '[a-zA-Z]')" ];then
   dockerfile=Dockerfile.prod
   fi
    ;;
  *)
  echo $BRANCH_NAME
    dockerfile=Dockerfile.develop
esac

services=$(cat $(dirname $0)/service-manifest.txt)
for s in $services
do
[ -f $TMP_IMG ] && cat /dev/null > $TMP_IMG
docker build -t ${s}:${tag}  -f $(dirname $0)/docker/$dockerfile . | tee -a $TMP_IMG
start_scan_local "$(cat $TMP_IMG| tail -n1|awk '{print $3}')"
[ $? -ne 0 ] && { export SCAN_STATUS=fail ; echo "Image has vulnerabilities,Please check and fix" ; } || :
cat /dev/null > $TMP_IMG
done

echo $SCAN_STATUS > $SCAN_LOG
