#!/bin/bash
exit 0
# 
#  Python OTEL SDK 環境變數
#    https://opentelemetry-python.readthedocs.io/en/latest/sdk/environment_variables.html
# 
# ---------------------------------------------------------------------------------

pip install opentelemetry-distro opentelemetry-exporter-otlp

opentelemetry-bootstrap --action=install

# WARNING: 目前安裝的一堆東西, LinuxFoundation 說這個 lib 有 Bug (我自己跑起來也是會噴 exception), 因此先砍~
pip uninstall opentelemetry-instrumentation-aws-lambda


export OTEL_SERVICE_NAME=YOUR_SERVICE_NAME

export OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true

### Run app with OTel auto instrumentation
opentelemetry-instrument python app.py

opentelemetry-instrument \
  --metrics_exporter otlp \
  --logs_exporter otlp \
  --traces_exporter otlp \
  --service_name YOUR_SERVICE_NAME \
  flask run -p 5000