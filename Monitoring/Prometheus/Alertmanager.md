# AlertManager

- 用來協助 Prometheus 發送警告資訊
    - 獨立於 Prometheus 的元件
    - 本身支援 HA
- AlertManager 之間避免重複警告, 彼此間引用了 Gossip 來同步 警告資訊


```mermaid
flowchart LR

p1["Prometheus"] --> router;
p2["Prometheus"] --> router;

subgraph Alertmanager
    router
end

router --> slack;
router --> email;
router --> webhook;
```
