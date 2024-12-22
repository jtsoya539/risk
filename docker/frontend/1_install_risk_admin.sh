#!/bin/bash

if [ "${IGNORE_APEX}" == "TRUE" ]; then
echo "BUILDER: APEX applications installation ignored"
else
echo "BUILDER: APEX applications installation started"

# Install APEX applications
sql $RISK_DB_USER/$RISK_DB_PASSWORD@database:1521/XEPDB1
exit

fi;