# iptables

- iptables 底下有 tables. 每個 TABLEs 又有不同的 CHAINs, CHAINs 底下則為 RULEs
  - filter (此為 default table)
    - 主要有 2 chains
      - INPUT
        - 對於 INPUT chain 來說, source 為 remoteIP; destination 為 localhost
      - OUTPUT
        - 對於 OUTPUT chain 來說, source 為 localhost; destination 為 remoteIP
  - nat
    - 用來過濾後端封包
  - mangle
    - 用來過濾特殊 flag 的封包
