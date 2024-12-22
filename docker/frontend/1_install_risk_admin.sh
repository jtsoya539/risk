#!/bin/bash

if [ "${IGNORE_APEX}" == "TRUE" ]; then
echo "BUILDER: APEX applications installation ignored"
else
echo "BUILDER: APEX applications installation started"

# Install APEX applications
sql risk/risk@database:1521/XEPDB1
exit

fi;