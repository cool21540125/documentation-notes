[replicaof](https://redis.io/commands/replicaof)

> Since 5.0.0+

可藉由設定 `REPLICAOF NO ONE` 來讓自己變回 master (停止 replication), 但並不會捨棄原本 replication 的 dataset

如果原本已經設定 replicaof, 然後現在更換成另一台, 則舊的 dataset 將會被捨棄