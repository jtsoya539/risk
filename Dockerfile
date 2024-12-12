FROM gvenzl/oracle-xe:18.4.0-slim-faststart

ENV ORACLE_PASSWORD=oracle

ENV JAVA_HOME /usr/lib/jvm/msopenjdk-21-amd64
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=mcr.microsoft.com/openjdk/jdk:21-ubuntu $JAVA_HOME $JAVA_HOME

COPY /source/database /usr/src/risk/source/
COPY /test/database /usr/src/risk/test/
COPY *_docker_*.sh /container-entrypoint-initdb.d/