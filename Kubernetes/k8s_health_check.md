
- [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- 2022/09/24

- Health Check 分成下列幾種:
  - Liveness
    - kubelet 用此指標判斷 是否 restart container
  - Readiness
    - kubelet 用此指標判斷 是否該 container 已 ready to start accepting traffic
  - Startup Probes
    - kubelet 用此指標判斷 when a container application has started


# Liveness

### Define a liveness command

```yaml
### pods/probe/exec-liveness.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec  # pod nam
spec:
  containers:
  - name: liveness
    image: registry.k8s.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
```

- Container start 時執行:
  - `/bin/sh -c "touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600"`
- 


### Define a liveness HTTP request

```yaml
### pods/probe/http-liveness.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-http
spec:
  containers:
  - name: liveness
    image: registry.k8s.io/liveness
    args:
    - /server
    livenessProbe:
      httpGet:  # Status Code 介於 2xx 與 3xx 視為 healthy
        path: /healthz
        port: 8080
        httpHeaders:
        - name: Custom-Header
          value: Awesome
      initialDelaySeconds: 3  # 初始化後多久開始檢測
      periodSeconds: 3  # 每隔一段時間做檢測
```

- 


### Define a TCP liveness probe

```yaml
### pods/probe/tcp-liveness-readiness.yaml
apiVersion: v1
kind: Pod
metadata:
  name: goproxy
  labels:
    app: goproxy
spec:
  containers:
  - name: goproxy
    image: registry.k8s.io/goproxy:0.1
    ports:
    - containerPort: 8080
    readinessProbe:
      tcpSocket:
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      tcpSocket:
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 20
```


### Define a gRPC liveness probe

```yaml
### pods/probe/grpc-liveness.yaml
apiVersion: v1
kind: Pod
metadata:
  name: etcd-with-grpc
spec:
  containers:
  - name: etcd
    image: registry.k8s.io/etcd:3.5.1-0
    command: [ "/usr/local/bin/etcd", "--data-dir",  "/var/lib/etcd", "--listen-client-urls", "http://0.0.0.0:2379", "--advertise-client-urls", "http://127.0.0.1:2379", "--log-level", "debug"]
    ports:
    - containerPort: 2379
    livenessProbe:
      grpc:
        port: 2379
      initialDelaySeconds: 10
```

- gRPC 不支援 named port (不能定義 livenessProbe.grpc.name: xxx 啦)


### Protect slow starting containers with startup probes

```yaml
ports:
- name: liveness-port
  containerPort: 8080
  hostPort: 8080

livenessProbe:
  httpGet:
    path: /healthz
    port: liveness-port
  failureThreshold: 1
  periodSeconds: 10

startupProbe:
  httpGet:
    path: /healthz
    port: liveness-port
  failureThreshold: 30
  periodSeconds: 10
```

- 最多能有 failureThreshold * periodSeconds 秒 來做 startup
  - failureThreshold : default 3. 連續探測多少次失敗才會被認定失敗
  - periodSeconds : default 10s. 探測頻率

### 