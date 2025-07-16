# RDS SWAP issue

RDS 或是 DB 對於 SWAP 的使用, 通常會在 RAM 不夠使用, 或者是 pages 已經過了一段時間沒再次被使用時, 則這些 pages 會被移入到 SWAP.

OS (指 Linux) 並不會經常性地清除 SWAP (因為這也需要操作成本), 因此 SwapUsage metrics 並不會沒事隨著時間自己降到 0

# Reference

https://www.youtube.com/watch?v=KoB-E1vsIXM
