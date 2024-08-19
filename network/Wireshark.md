# 一般使用

- Wireshark > View > Coloring Rules 可以客製化顏色
- Wireshark > View > Internals > Supported Protocols 可找到所有 Wireshark 支援的 Display Filter 格式

# Display Filter 顯示過濾器

- Display Filter 僅適用於 Wireshark (不同於 Capture Filter 的格式適用在各種網路抓包)
- Example
  - `tcp.port in {80 443 8000..8888}` 等同於 `tcp.port == 80 || tcp.port == 443 || tcp.port >= 8000 && tcp.port <= 8888`
  - `eth.src[0:3] == 00:00:83` 從 0 開始切 3 段
  - `eth.src[1-2] == 00:83` 取出 1 ~ 2 段
  - `eth.src[:4] == 00:00:83:00` 由開始處到截止處(:4)
  - `eth.src[0:3,1-2,:4,4:,2] == 00:00:83:00:83:00:00:83:00:20:20:83` 可用 , 分開多組條件
  - `tcp.flags.reset==1`

# Capture Filter 捕獲過濾器

- 適用於各種網路抓包工具的解析語法, 此語法又被稱為 BPF, Berkeley Packet Filter
- `Type: {host|port|portrange|net|...}`
- `Dir: {src|dst|src or dst|src and dst}`
- `Proto: {ether|ip|ip6|tcp|udp|icmp|...}`
- `Other: {gateway|broadcast|multicast|less|greater|...}`
  - `gateway IP` == `ether host ehost and host not host`
  - `broadcast`, ex: `ether broadcast` 或 `ip broadcast`
  - `multicast`, ex: `ip multicast` 或 `ip6 multicast`

| Dir        | Type      | Primitives     | Proto      | Other |
| ---------- | --------- | -------------- | ---------- | ----- |
| dst        | host      | www.google.com |            |
| dst        | port      | 80             |            |
| -          |           |                | udp        |
| src or dst | portrange | 6000-8000      | tcp or ip6 |

- Example
  - `tcp[13]&4 == 4` 捕獲 TCP 中, RST 報文
  - `port 80 and tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420` 擷取 80 port & TCP Header 結束後的前 4 bytes 為 `GET` 的報文
    - `tcp[12:1]` 表示擷取 TCP Header 第 12 bytes 取整個 byte (也就是 OFFSET 及 Reserve)
    - `(tcp[12:1] & 0xf0)` 表示將前述片段, 與 `11110000` 計算取得該值 (也就是 OFFSET 片段)
    - `((tcp[12:1] & 0xf0) >> 2)` 表示將上述的 bits 轉換為 bytes
  - `dst host giftshopgw.systex.com`
