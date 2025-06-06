# Loki - Simple scalable mode

| abbr | Components      |
| ---- | --------------- |
| C    | Compactor       |
| D    | Distributor     |
| FE   | Query frontend  |
| I    | Ingester        |
| IG   | Index Gateway   |
| Q    | Querier         |
| QS   | Query Scheduler |
| R    | Ruler           |

```mermaid
flowchart TB

subgraph wt1["Write Target"]
  d1[D]
  i1[I]
end
subgraph wt2["Write Target"]
  d2[D]
  i2[I]
end
subgraph wt3["Write Target"]
  d3[D]
  i3[I]
end
subgraph rt1["Read Target"]
  fe1[FE]
  q1[Q]
end
subgraph rt2["Read Target"]
  fe2[FE]
  q2[Q]
end
subgraph bt["Backend Target"]
  C
  IG
  QS
  R
end

s(("Cloud Storage"))
wt1 -- write --> s
wt2 -- write --> s
wt3 -- write --> s
s -- read --> rt1
s -- read --> rt2
s <-- read/write --> bt
```
