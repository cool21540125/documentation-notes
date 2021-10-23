
- [(必看)More Podman - Rootfull containers, Networking and processes](https://raesene.github.io/blog/2020/02/23/More-Podman/)

```bash
$ brctl show
bridge name     bridge id               STP enabled     interfaces
cni-podman0             8000.de0b656f3465       no              vethbba94ede
                                                        vethc1fc13fd
$ docker run --rm --net mynet  --ip=192.168.166.3 --name c1 -h cg61 -d alpine sleep 360
Error: error running container create option: cannot set a static IP if joining additional CNI networks: invalid argument
```


## Feature

- Podman 將相關檔案存在 `$HOME/.local/share/containers/storage`
- Podman 對於 unprivileged containers 的 Networking, 使用 `slirp4netns` 程序來作輔助
- 使用 `conmon`w


## rootless v.s. rootful

- rootless container 使用 `slirp4nets` 來提供 Container IP address.