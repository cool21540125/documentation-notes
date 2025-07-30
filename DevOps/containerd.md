# Containerd

- Containerd 的配置主檔位置: `/etc/containerd/config.toml`


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

# 關於 Kubernetes 的 cgroup driver 的議題

Linux 的 cgroup driver 有兩種: `cgroupfs` 和 `systemd`

我們需要確認底下 3 者使用的 cgroup driver 一致:

- kubelet
- containerd (如果使用 containerd 作為 Container Runtime 的話)
- kubeadm (如果使用 kubeadm 的話)

然而, kubelet 和 containerd 的 cgroup driver 預設是不同的, 這可能會導致資源管理上的問題

- 關於 cgroup driver:
  - systemd 為 kubeadm 預設的 cgroup driver
  - kubcgroupfs 為 kubelet 和 containerd 預設的 cgroup driver

因此如果使用 kubeadm, 需要在 kubelet 和 containerd 的配置中指定 cgroup driver 為 systemd

- kubelet 的配置檔案通常位於 `/var/lib/kubelet/config.yaml` 或 `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`
  - 需要確認檔案內: `cgroupDriver: systemd`
  - 如果發現 kubelet 的 config file 消失了的話, 補救方式: `sudo kubeadm init phase kubelet-start`
- containerd 的配置檔案通常位於 `/etc/containerd/config.toml`
  - containerd 的配置檔則會因為 v1 與 v2 的差異而有所不同, 詳細配置自己上網找答案...
  - 然而不管 v1 還是 v2, 都要有: `SystemdCgroup = true`

```bash
sudo systemctl restart kubelet
systemctl status kubelet

sudo systemctl restart containerd
systemctl status containerd

```