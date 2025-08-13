# OpenTelemetry, OTel/o11y

- otlp
  - OpenTelemetry 的 Protocol, 用於傳輸 traces / metrics / logs
  - 支援 gRPC(4317 port) / HTTP(4318 port)


# OpenTelemetry environment variables

- [OpenTelemetry 官網的各種 Environment variables](https://opentelemetry.io/docs/languages/sdk-configuration/otlp-exporter/)

```bash
export OTEL_METRICS_EXPORTER="none"  # [none, otlp, console] OTel signals 發送到哪邊
export OTEL_LOGS_EXPORTER="none"     # [none, otlp, console] OTel signals 發送到哪邊
export OTEL_TRACES_EXPORTER="otlp"   # [none, otlp, console] OTel signals 發送到哪邊

### 設定 OTel 環境變數, 要我們的 OTel App 直接將 signal 傳給 OTel Collector
export OTEL_COLLECTOR_HOST=localhost

export OTEL_EXPORTER_OTLP_INSECURE=true  # 使用 http 而非 https

## 打算把 App signals 傳送到 OTel Collector 的 gRPC/HTTP (告知 OTel Collector 的 Endpoint)
export OTEL_EXPORTER_OTLP_ENDPOINT="YOUR_OTEL_COLLECTOR_HOST:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_ENDPOINT="YOUR_OTEL_COLLECTOR_HOST:4318"  # http 的 OTel Collector 端點

##
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"  # (default)
export OTEL_EXPORTER_OTLP_PROTOCOL="http/json"      # 
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"           # 

export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT="localhost:4317"  # gRPC 的 OTel Collector 端點

```

## OTel java (auto instrumentation)

a. 運行方式

```bash
### 1. 先去找最新版的 OTel JavaAgent - https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases

wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.18.1/opentelemetry-javaagent.jar

### 2. Run App with OTel JavaAgent
java -javaagent:./opentelemetry-javaagent.jar -jar target/YOUR_APP-0.0.1-SNAPSHOT.jar
```

b. 設定 OTel JavaAgent 專屬的環境變數

```bash
### 如果打算使用 auto(而非去改 Code 加上 annotation), 可用此種方式聲明後再來啟動 (便可用非侵入式的配置來實踐 OTel)
## Example 說明:
#     io.novatec.todobackend.TodobackendApplication 來自於 src/main/java 底下的路徑及檔名
#     [someInternalMethod] 則是該 TodobackendApplication.java 內的 method

## 使用不侵入 Code 的方式, 直接聲明哪個檔案的哪個 method 要被 OTel 監控
export OTEL_INSTRUMENTATION_METHODS_INCLUDE=io.novatec.todobackend.TodobackendApplication[someInternalMethod]

## 直接抑制 特定方法先排除在 OTel 監控之外 (縱使已有 OTel annotation)
export OTEL_INSTRUMENTATION_OPENTELEMETRY_INSTRUMENTATION_ANNOTATIONS_EXCLUDE_METHODS=io.novatec.todobackend.TodobackendApplication[someInternalMethod]

```

## OTel python (auto instrumentation)

- [Python OTEL SDK 環境變數](https://opentelemetry-python.readthedocs.io/en/latest/sdk/environment_variables.html)

```bash
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
```

# OTel overview

- OpenTelemetry 的 Sementic Conventions, 用於實作 Otel 回應屬性常見的 Keys
  - https://opentelemetry.io/docs/specs/semconv/

![OTel](./img/OTel.jpg)