#!/bin/bash

echo "BUILDER: Source installation started"

# Install headless
export SQLPATH="/usr/src/risk/source/:$SQLPATH"
sqlplus sys/$ORACLE_PASSWORD@//localhost/XEPDB1 as sysdba @install_headless.sql $RISK_DB_USER $RISK_DB_PASSWORD

# Install modules
export SQLPATH="/usr/src/risk/source/modules/msj/:$SQLPATH"
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 install_dependencies.sql
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 @install.sql

# Install migrations
export SQLPATH="/usr/src/risk/source/migrations/mig_000001/:$SQLPATH"
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000002/:$SQLPATH"
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000003/:$SQLPATH"
sqlplus $RISK_DB_USER/$RISK_DB_PASSWORD@//localhost/XEPDB1 @install.sql