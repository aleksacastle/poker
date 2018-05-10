#!/usr/bin/env bash
set -e # Exit on error

cd ~

tar -xvf scm_artifact.tar
ls -l

# If an argument was passed, assume it was a timestamp to be used
if [ ! -z "$1" ]; then
  DATESTRING="-d @${1}"
fi

YEAR=`date $DATESTRING -u +%Y`
MONTH=`date $DATESTRING -u +%m`
DAY=`date $DATESTRING -u +%d`
TIME=`date $DATESTRING -u +"%k:%M:%S UTC"`
SECONDS=`date $DATESTRING -u +%s`

sed -i "s/year not set/$YEAR/g" scm_artifact/index.html
sed -i "s/month not set/$MONTH/g" scm_artifact/index.html
sed -i "s/day not set/$DAY/g" scm_artifact/index.html
sed -i "s/time not set/$TIME/g" scm_artifact/index.html
sed -i "s/seconds not set/$SECONDS/g" scm_artifact/index.html


if [ -f $ARTIFACT_DIR/repo_info.html.txt ]; then
  while IFS='' read -r line || [[ -n "$line" ]]; do
    BUILD_INFO_HTML="${BUILD_INFO_HTML}${line}<br />"
  done 
fi

if [ -f $ARTIFACT_DIR/previous_sessions.html.txt ]; then
  while IFS='' read -r line || [[ -n "$line" ]]; do
    EXTRA_HTML="${EXTRA_HTML}${line}<br />"
  done
fi

if [ -f $ARTIFACT_DIR/errors.txt ]; then
  while IFS='' read -r line || [[ -n "$line" ]]; do
    ERROR_HTML="${ERROR_HTML}${line}<br />"
  done
fi

sed -i "s/build info not set/$BUILD_INFO_HTML/g" scm_artifact/index.html
sed -i "s/previus sessions not set/$EXTRA_HTML/g" scm_artifact/index.html
sed -i "s/error not set/$ERROR_HTML/g" scm_artifact/index.html
