# OSI data header

- L7 / L6 / L5
  - Payload
- L4
  - TCP + Payload
  - 加上 Header `src PORT dst PORT`
- L3
  - IP + (TCP + Payload)
  - 加上 Header `src IP dst IP`
- L2
  - MAC + (IP + TCP + Payload) + FCS\*
  - 加上 Header `src MAC dst MAC`

```
  L2       L3        L4
 S:MAC    S:IP      S:PORT    資料內容
 D:MAC    D:IP      D:PORT
----------------------------------------
|  MAC   |   IP   | TCP/UDP | Payload  |
| Format | Format |  Format |          |
----------------------------------------
```
