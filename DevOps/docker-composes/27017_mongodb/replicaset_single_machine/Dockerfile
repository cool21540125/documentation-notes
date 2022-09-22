FROM mongo:4.4-bionic
COPY init/* /docker-entrypoint-initdb.d/
COPY init/keyfile /etc/keyfile
RUN chmod 600 /etc/keyfile && \
    chmod a+x /docker-entrypoint-initdb.d/* && \
    chown mongodb. /etc/keyfile