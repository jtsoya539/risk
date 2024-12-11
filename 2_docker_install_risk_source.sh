export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

# Create user
export SQLPATH="/usr/src/risk/source/:$SQLPATH"
sqlplus sys/oracle@//localhost/XEPDB1 as sysdba @create_code_user.sql risk risk

# Install source
sqlplus risk/risk@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/modules/msj/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000001/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000002/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @install.sql

export SQLPATH="/usr/src/risk/source/migrations/mig_000003/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @install.sql