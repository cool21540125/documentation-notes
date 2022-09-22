FROM registry:2.7.1

COPY ./config.yml /etc/docker/registry/config.yml

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]