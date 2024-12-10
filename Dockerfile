FROM gvenzl/oracle-xe:18.4.0-slim-faststart
ENV ORACLE_PASSWORD=oracle
COPY /source/database /usr/src/risk/source/
COPY /test/database /usr/src/risk/test/
COPY 1_docker_install_utplsql.sh 2_docker_install_risk.sh /container-entrypoint-initdb.d/