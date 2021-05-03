FROM zabbix/zabbix-server-mysql:5.0.10-centos AS src

FROM mysql:5.7
COPY --from=src /database/mysql/create.sql /docker-entrypoint-initdb.d/.
RUN 