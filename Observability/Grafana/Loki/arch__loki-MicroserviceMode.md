# Loki - Microservice Mode

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

```
  D  D  D                Q  QS  R
  I  I  C                FE  IG

   \  \  \            /  /  /
     write           read
      \  \  \      /  /  /

        Cloud Storage
```
