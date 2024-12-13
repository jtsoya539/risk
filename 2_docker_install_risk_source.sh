#!/bin/bash

# Create user
export SQLPATH="/usr/src/risk/source/:$SQLPATH"
sqlplus sys/$ORACLE_PASSWORD@//localhost/XEPDB1 as sysdba @create_code_user.sql $RISK_APP_USER $RISK_APP_USER_PASSWORD

# Install source
sqlplus $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/modules/msj/:$SQLPATH"
sqlplus $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000001/:$SQLPATH"
sqlplus $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000002/:$SQLPATH"
sqlplus $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000003/:$SQLPATH"
sqlplus $RISK_APP_USER/$RISK_APP_USER_PASSWORD@//localhost/XEPDB1 @install.sql