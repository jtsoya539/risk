export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

# Install tests
export SQLPATH="/usr/src/risk/test/:$SQLPATH"
sqlplus risk/risk@//localhost/XEPDB1 @install.sql