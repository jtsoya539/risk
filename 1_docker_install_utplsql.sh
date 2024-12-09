#!/bin/bash
# Get the url to latest release "zip" file
UTPLSQL_DOWNLOAD_URL=$(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g')
# Download the latest release "zip" file
curl -Lk "${UTPLSQL_DOWNLOAD_URL}" -o utPLSQL.zip
# Extract downloaded "zip" file
unzip utPLSQL.zip

export SQLPATH="$PWD/utPLSQL/source:$SQLPATH"
sqlplus sys/oracle@//localhost/XEPDB1 as sysdba @utPLSQL/source/install_headless.sql