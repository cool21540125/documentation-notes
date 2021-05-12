FROM mysql:5.6.28

RUN apt-get update && \
    apt-get install apt-file -y && \
    apt-file update && \
    apt-get install vim -y && \
    echo 'alias ll="ls -al"' >> ~/.bashrc

WORKDIR /var/lib/mysql