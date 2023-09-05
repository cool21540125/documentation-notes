
# VPC Peering

- Privately connect two VPCs using AWS' network
    - 利用 AWS network privately connect 2 VPC (連結不同 VPC 啦)
    - 讓 VPCs 之間就像是在同樣的 network 裡頭包含了
        - cross region, cross account
        - 不能有 operlapping CIDRs
    - 配置完以後, 還需要自行配置 Route Table (兩邊都需要配置)
- 可讓不同的 VPC, 搞得就像是個 LAN
- 如果要 expose service 給其他 VPC, 這是個比開 public 還要好的做法
    - 不過更好的做法, 可使用 [PrivateLink](#vpc-endpoint-services-aws-privatelink)
- 重要範例:
    - 若 A 及 B 做好了 peering && B 及 C 做好了 peering
        - A 與 C 依然無法 connect (朋友的朋友, 未必是我朋友)
        - VPC Peering connection is NOT transitive
