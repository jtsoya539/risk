export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252
export SQLPATH="/usr/src/risk/source/:$SQLPATH"
sqlplus sys/oracle@//localhost/XEPDB1 as sysdba @create_code_user.sql risk risk
sqlplus risk/risk@//localhost/XEPDB1 @install.sql
export SQLPATH="/usr/src/risk/source/modules/msj/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @modules/msj/install.sql
sqlplus risk/risk@//localhost/XEPDB1 @migrations/mig_000001/install.sql
sqlplus risk/risk@//localhost/XEPDB1 @migrations/mig_000002/install.sql
sqlplus risk/risk@//localhost/XEPDB1 @migrations/mig_000003/install.sql