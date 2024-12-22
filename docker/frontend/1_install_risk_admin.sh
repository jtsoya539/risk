#!/bin/bash

if [ "${IGNORE_APEX}" == "TRUE" ]; then
echo "BUILDER: APEX applications installation ignored"
else
echo "BUILDER: APEX applications installation started"

# Install APEX applications
export SQLPATH="/usr/src/risk/source/apex/:$SQLPATH"
sql SYSTEM/oracle@database:1521/XEPDB1 @w2000988041184963.sql
#sql SYSTEM/oracle@database:1521/XEPDB1 @f539.sql

fi;