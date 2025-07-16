# Containerd

```bash
### Containerd 的配置文件
cat /etc/containers/registries.conf
# -------------- 增加 Registry --------------
## 這邊是如果在中國境內的鏡像配置方式, 身處自由地區無需理會
[[registry]]
location = "gcr.io"
  [[registry.mirrors]]
  location = "docker.m.daocloud.io"
# ------------------------------------------

```