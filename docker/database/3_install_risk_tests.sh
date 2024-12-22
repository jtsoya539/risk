#!/bin/bash

if [ "${SKIP_TESTS}" == "true" ]; then
echo "BUILDER: Tests installation and execution ignored"
else
echo "BUILDER: Tests installation and execution started"

# Install tests
export SQLPATH="/usr/src/risk/test/:$SQLPATH"
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 @install.sql

fi;