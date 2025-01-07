FROM public.ecr.aws/lambda/provided:al2023-rapid-arm64

ENV BINARY=yq_linux_arm64
ENV VERSION=v4.44.5

RUN dnf install -y wget unzip jq && \
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && rm -f awscliv2.zip && \
    ./aws/install

COPY bootstrap /var/task/bootstrap
COPY ecs_cost_saving.sh .

CMD ["ecs_cost_saving.start"]
