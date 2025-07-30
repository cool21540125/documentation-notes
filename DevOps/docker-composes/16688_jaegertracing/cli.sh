#!/bin/bash
exit 0
# --------------------------------------------------------

docker compose -f all-in-one-jaegertracing.yaml up -d


# 直接運行 jaeger
docker run -d --name jaeger \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 4317:4317 \
  -p 4318:4318 \
  jaegertracing/all-in-one


### 