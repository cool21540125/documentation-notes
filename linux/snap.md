# snap

- https://snapcraft.io/docs/installing-snapd

Linux 的新一代 pkg manager


# snap channel

完整的 snap Channel Name 為 `<track>/<risk>/<branch>`

- tracks      : 發佈多種 releases 的機制
    - snap 的 default track 為 `latest` (如果未聲明的話, 預設會由 `latest/stable` 來安裝 PKG)
- risk-levels
    - 有 4 種 Risk Level: stable | candidate | beta | edge
    - 預設會使用 stable
- branches
    - 可省略的 channel fine-grained 機制


# snap install

```bash
### snap 安裝套件, 除了聲明完整的 channel:
# --channel=<risk-level>
# 也可直接聲明:
# --stable
# --candidate
# --beta
# --edge
```
