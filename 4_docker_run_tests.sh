#!/bin/bash

if [ "${SKIP_TESTS}" == "true" ]; then
  echo "BUILDER: Tests installation and execution ignored"
else
  echo "BUILDER: Tests installation and execution started"

# Get the url to latest release "zip" file
DOWNLOAD_URL=$(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL-cli/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g')
# Download the latest release "zip" file
curl -Lk "${DOWNLOAD_URL}" -o utPLSQL-cli.zip
# Extract downloaded "zip" file
unzip utPLSQL-cli.zip

export JAVA_TOOL_OPTIONS='-Dfile.encoding=utf8'
utPLSQL-cli/bin/utplsql run $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1

fi;