#!/bin/bash
# Get the url to latest release "zip" file
DOWNLOAD_URL=$(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL-cli/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g')
# Download the latest release "zip" file
curl -Lk "${DOWNLOAD_URL}" -o utPLSQL-cli.zip
# Extract downloaded "zip" file
unzip utPLSQL-cli.zip

export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252
export JAVA_TOOL_OPTIONS='-Dfile.encoding=utf8'
utPLSQL-cli/bin/utplsql run risk/risk@//localhost/XEPDB1