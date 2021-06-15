# 中英文對照 && 專有名詞


## Vocabulary

- ad-hoc(ad hoc) : 特設, 專案的, 臨時的, 特定目的的
- alphanumeric : 標點符號
- artificially : 人為地
- attributes (headers)
- authentication : 認證
- auto-positioning : 自動定位
- authorization : 授權
- backlog : 積壓
- back slash : 反斜線
- behind the scenes : 幕後
- boilerplate: 樣板
- bootstrap configuration file : 引導程序配置文件
- cascade: 串連
- confined : 受限
- congestion : 擁塞
- contention : 爭奪, 爭用
- cow, copy-on-write strategy: 寫時復制策略
- credential : 憑證
- cryptographically : 加密
- elevate : 提升(通常指使用 具有權限 的 使用者)
- eligible : 有資格的
- enumerable : 可列舉的
- expression : 運算式
- fabric : 布, 結構, 構造, 品質, 織品
- failure-prone : 容易失敗
- FWIW : for what it's worth (用在 `不知道講出來有沒有用, 但就我所知是這樣` 的情境)
- gotcha : 陷阱
- hassle : 麻煩
- IIUC : if I understood correctly
- imitate/mimic : 模仿
- immutable : 不可變的
- in favor of : 有利於, 取而代之
- intelliSense : 提示
- IOW : in other words
- IP Masquerade: IP掩蔽
- linter : code 語法 check
- malformed : 異常
- marshal : 整頓
- masquerade : 偽裝
- more or less : 或多或少
- one-off : 一次性
- on the fly : 動態產生
- opaque : 含糊的, 不透明的
- Operation not permitted : 不具有此指另作用的檔案 的權限
- orchestrate : 編排
- oval : 橢圓形
- overlap : 交疊
- passphrase : 密語; 嚴格來講, 此非密碼 (Not a password)
- payload (body)
- perimeter network : (同 DMZ)
- permission : 許可
- Permission denied : 無權使用此指令
- persist : 堅持, 持續
- poller : 輪循器
- portal : 門戶
- replica : 即時備援 (即時複製一份到其他節點的概念, HA), 資料備份的另一種可行性作法
- retention : 保留
- routing mesh : 路由網路
- sharding : 分片(把東西拆成幾分的概念吧??)
- SIGSEGV : 記憶體區段錯誤
- snippets : 片段
- space bar : 空白鍵
- sponsor : 發起人
- starting from scratch : 從零開始
- strike a balance : 沖帳
- stub : 存根
- throughput : 吞吐量
- tilde : 波浪號
- throttle : 節流控制器. 軟體方面, 可用來約束像是特定使用者, 一天只能請求一次
- under the hood : 在引擎蓋底下(有點封裝的概念, 複雜的細節人家幫你包好了)
- unmarshal: 解組
- validate : 驗證
- vast : 極大的
- wildcard characters : 萬用字元 (「*」啦)
- whichever : 任何
- wireframe : 線框
- workaround : 解決方法
- workhorse : 主力


#### 一些名詞

abbr   | Termonology                                 | Category        | Note
------ | ------------------------------------------- | --------------- | ------------
AD     | Active Directory                            | 集中驗證         |
BSD    | Berkeley Software Distribution              | DNS             |
CA     | Certification Authority, 憑證授權中心         | 資安            |
CRI    | Container Runtime Interface                 | Container        | 
CSR    | Certificate Signing Request, 憑證簽署請求     | 資安            |
DHCP   | Dynamic Host Configuration Protocol         | TCP/IP          |
DMZ    | Demilitarized Zone                          | 資安            |
DN     | Distinguished Name                          | 集中驗證         |
EIP    | Elastic IP                                  | AWS             | 固定IP
GDPR   | General Data Protection Regulation          | 資安            |
GWF    | Great Fire Wall                             | 監控            | 中國長城...
IPA    | Identiti, Policy and Auditing               | 集中驗證         | 提供 LDAP & Kerberos
MITM   | Man-In-The-Middle attack                    | 資安            | [MITM](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)
KDC    | Key Distribution Centers                    | 集中驗證         |
LDAP   | Lightweight Directory Access Protocol       | 集中驗證         |
NAT    | Network Address Translation                 | IPv4            |
NFS    | Network File System                         | Linux           |
OCSP   | Online Certificate Status Protocol          | 在線憑證狀態協定 |
PERT   | Program Evaluation and Review Technique     | 專案管理        | [PERT 網路分析法](https://wiki.mbalib.com/zh-tw/PERT%E7%BD%91%E7%BB%9C%E5%88%86%E6%9E%90%E6%B3%95)
POC    | Proof of Concept                            | DevOps          |
SEO    | Search Engine Optimization                  | FrontEnd        |
SLA    | Service Level Agreement                     | 服務層級協定     | 
SPF    | Single Point of Failure                     | 單點失效         | SPoF
SSG    | Static Site Generator                       | FrontEnd        | 前端框架產生器, ex: Hugo, Hexo, MkDocs
SSL    | Secure Sockets Layer                        | 資安            |
SSO    | Single Sign-On                              | 集中驗證         | 單點登錄
TDD    | Test-Driven-Development                     | DevOps          |
THP    | Transparent Huge Pages                      | 透明大頁面       | 作業系統記憶體的東西
TLB    | Translation Lookaside Buffer                | 轉換後備緩衝區   | 
TLS    | Transport Layer Security                    | 資安            |
VPC    | Virtual Private Cloud                       | Cloud           |
VPN    | Virtual Private Network                     | 虛擬私有網路    | servers間點對點加密溝通 (軟體翻牆的其中一種方式)
WAL    | Write-ahead logging                         | 預寫式日誌      | RDBMS 為了維持 原子性 & 持久性, 將所有修改提交前都先寫入 log