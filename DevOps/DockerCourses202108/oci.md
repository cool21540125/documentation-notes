# Open Container Initiative, OCI

- [About the Open Container Initiative](https://opencontainers.org/about/overview/)
- [Container Runtimes Part 1: An Introduction to Container Runtimes](https://www.ianlewis.org/en/container-runtimes-part-1-introduction-container-r)
  - Part 1: Intro to Container Runtimes: why are they so confusing?
- [Container Runtimes Part 2: Anatomy of a Low-Level Container Runtime](https://www.ianlewis.org/en/container-runtimes-part-2-anatomy-low-level-contai)
  - Part 2: Deep Dive into Low-Level Runtimes
  - 負責處理 Container 運行的機制
- [Container Runtimes Part 3: High-Level Runtimes](https://www.ianlewis.org/en/container-runtimes-part-3-high-level-runtimes)
  - Part 3: Deep Dive into High-Level Runtimes
  - 負責 Container Image 的 transport && management
  - unpacking the image, and passing off to the low-level runtime to run the container
- [Container Runtimes Part 4: Kubernetes Container Runtimes & CRI](https://www.ianlewis.org/en/container-runtimes-part-4-kubernetes-container-run)
  - Part 4: Kubernetes Runtimes and the CRI

---

- OCI 用來規範 imagespec 及 runtimespec
  - imagespec 規範 **image 應該如何 build** && **image 的格式**
  - runtimespec 規範 **container runtime 應該如何 develop** && **container runtime 的標準**
- OCI 旨在實現容器格式和運行時的標準化，從而促進容器技術的發展和推廣

### 造就 Container Runtime 如此令人混淆的主因

Docker 起始於 2013, 主要有底下幾個功能:

- Container Image Format
- 完成了 Build Image 的方式 (docker build)
- 完成了用來管理 Image 的方式 (docker rmi)
- 完成了管理 Container 的方式 (docker ps, docker rm)
- 完成了分享 Image 的方式 (docker pull, docker push)
- 完成了運行 Container 的方式 (docker run)

在當時 Docker 雖說是個整體式的系統, 但上述功能中, 都是使用相互獨立的許多工具來達成. 因而當時許多大廠, Google, CoreOS, Docker 開始研擬 `Open Container Initiative, OCI`. 並於當時將運行 Container 的代碼拆分, 並名為 `runc`, 將之捐贈給了 OCI, 作為實作 OCI runtime specification 的參考依據.

而好幾度被世人認為很偉大的 Docker, 在上述的功能之中, 只有明確的實作出 **如何運行 Container**. 而當你使用 `docker run` 的時候, 實際上就是做了底下的動作:

1. 下載 Image
2. 將 Image 解開成為一個 bundle (將 Image 內部多層的結構扁平化為單一檔案系統)
3. 從 bundle 來運行 Container

Docker 只有完成上述第三點, only the "running the container" part that made up the runtime

從此之後, 因認知的不同, 又或者說式定義的不同, 從而導致後面千千萬萬名軟體從業人員對此產生種種的不解與困惑.

### Container Runtime

單單的提到 Container runtime, 或許就有在不少文章中看到 _runc_, _lxc_, _cri-o_, _containerd_, 他們本身都是 Container runtime 的實作

從底層至應用面的角度, 大致上可以把他們做底下的概念性劃分:

```
Low Level <------------------------> High Level

*********                        lxc
*********                        runc
         ******************      cri-o
               ****************  containerd
************************         rkt
```
