
# AWS Organizations

- 企業切割帳號, 用 *Master Account* 來統一管理旗下的 *Member Account*
    - Organization Unit, OU 的管理, 可依照 Env 拆分, ex: Dev, Test, Prod, ... 或是依照 Department 拆分
    - *Member Account* 也可能因為公司拆分等因素, 因此有可能會有 migration 的問題 (從 Organization 裏頭移除)
        - 因為一個 Account 一次只能加入一個 Organization, 因此需先退出 Original Org, 再加入倒 New Org
        - 但如果要 migrate *Master Account*, 只能土炮退出所有 *Member Account*, delete org, create new org, 再 invite...
    - 納入 Organization 以後, 也可使用 API 來 create AWS Account
    - 可有 Consolidated Bill, 享有多買多優惠的許多折扣
- AWS Organization Account 對於要共享給所有 Org Accounts 共用的 S3 Bucket, 給加上 `aws:PrincipalOrgID` 這個 condition. 即可讓 Accounts 們來做 access (不用做額外個別設定), 實用情境像是彙整 Logging Bucket


# Organization Policy

可以針對整個 Organization, 依需求, 可自行啟用下面 4 種 policies:


## AI services opt-out policies

## Backup policies

## Service control policies, SCP

- SCP 與 IAM 相互牴觸時, 以 OU 內的 SCP 為主
- 用來對 IAM action 設立 黑白名單
- 可套用到 *OU Level* 或 *Account Level*
- 無法作用到 *Master Account*
- SCP 會將權限套用到 *Member Account* 底下的所有 users && roles (包含 root account)
    - 不過不包含 *service-linked roles*
- 假如 OU 已被 deny 某個 action, 而在 OU 底下, 即使是 root 被 allow 某個 action, 也無法執行此 aciton


## Tag policies

- 可用這種方式來統一規劃整個 Organizations 使用的 Tag keys
