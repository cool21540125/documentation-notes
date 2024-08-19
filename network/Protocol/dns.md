# DNS

- 2018/06/12

## 名詞

- DDNS, 似乎可以用來幫助 Host 每 24 hrs 更新 IP 的時候, 重新導向回來. 避免 IP 換了以後就連不回來 (啥?)
- domain apex : 就是我們買到的 domain 啦, ex: google.com, tonychoucc.com, yahoo.com
- DNS Query, 分成:
  - Resursive Query : DNS Client 向 DNS Server 的查詢
  - Iterative Query : DNS Servers 之間的查詢
    - root name server 只接受這種 query

> DNS NameSpace:
> 將 IP 服務等命名, 並使用階層結構將這些名字組織起來的結果

> DNS Domain:
> 在 DNS NameSpace 中, 可含有下層的節點 => `共用相同識別尾碼`的東西的集合

> DNS Zone:
> 為分散管理, 在 DNS NameSpace 切割出的連續區域. 不同的 Zone 必有各自的 database(file 或 AD 中的容器) 儲存自己 Zone 中的 Records. 不同的　 Zone 可由不同組人管理.

> Fully Qualified Domain Name(FQDN):
> 在 DNS NameSpace 中, 節點的完整名稱. 轉換規則: 由下往上, 每層加「.」區隔

## Resource Record

| Zone Type            | Each Zone | Full content | Permission | Application                                                                                                 |
| -------------------- | --------- | ------------ | ---------- | ----------------------------------------------------------------------------------------------------------- |
| paimary(Master file) | 1         | Y            | R/W        | 讓管理者管理 Zone 中的 Resource Record 提供 client 或其他 DNS Server 查詢                                   |
| secondary            | N         | Y            | Readonly   | 會分擔 Primary Zone 的 DNS Server(Master Server) 的負擔, 或在 Primary Zone 的 DNS Server 故障時仍能提供查詢 |

# 名稱解析流程

若 DNS Server 內沒有要查詢的資料庫檔案, 則會前往 下列 2 者之一查詢:

- root (.)
- forwarders

## Windows 10

會依照下列 1~5 的順序來作 名稱解析

1. 是否為自己的 hostname

```powershell
> HOSTNAME
520-GG0006-1

> ping 520-GG0006-1
Ping 520-GG0006-1.tony.com [fe80::477:6844:2b45:5912%5] (使用 32 位元組的資料):
回覆自 fe80::477:6844:2b45:5912%5: 時間<1ms
...
```

2. [從 Resolver Cache 尋找](https://www.tenforums.com/tutorials/69648-display-dns-resolver-cache-windows.html) (動態快取(之前從 DNS 問到的))

```powershell
> ipconfig /displayDNS

Windows IP 設定

  vortex.data.microsoft.com
  ----------------------------------------
    記錄名稱 . . . . . : vortex.data.microsoft.com
    記錄類型 . . . . . : 5
    存留時間  . .  . . : 184
    資料長度 . . . . . : 8
    區段 . . . . . . . : 答案
    CNAME 記錄  . . . .: asimov.vortex.data.microsoft.com.akadns.net

    記錄名稱 . . . . . : asimov.vortex.data.microsoft.com.akadns.net
    記錄類型 . . . . . : 5
    存留時間  . .  . . : 184
    資料長度 . . . . . : 8
    區段 . . . . . . . : 答案
    CNAME 記錄  . . . .: geo.vortex.data.microsoft.com.akadns.net

    ...(超多~~~)...

    www.sce.pccu.edu.tw
    ----------------------------------------
    記錄名稱 . . . . . : www.sce.pccu.edu.tw
    記錄類型 . . . . . : 1
    存留時間  . .  . . : 1726
    資料長度 . . . . . : 4
    區段 . . . . . . . : 答案
    (主機) 記錄 . . . .: 140.137.200.141

> ping 140.137.200.141      # 從上面的快取中找到的

Ping 140.137.200.141 (使用 32 位元組的資料):
回覆自 140.137.200.141: 位元組=32 時間=119ms TTL=111
...
```

3. 查詢 HOSTS (靜態快取(使用者自行增加))

```powershell
> type C:\Windows\System32\drivers\etc\HOSTS
#
127.0.0.1 localhost
::1 localhost
```

4. 詢問 DNS Servrer

「Windows 開始(右鍵) > 網路連線(W) > 狀態/變更您的網路設定/變更介面卡選項 > (選取上網用的網卡) > 內容(P) > 網路功能/網際網擄通訊協定第 4 版(TCP/IPv4) > 內容(R) > 一般/進階(V) > DNS/附加這些 DNS 尾碼(依順序)(H)」看看這邊有沒有設定, 一個接一個傳給所指定的 DNS 來查詢

5. 詢問 DNS Servrer

「Windows 開始(右鍵) > 網路連線(W) > 狀態/變更您的網路設定/變更介面卡選項 > (選取上網用的網卡) > 內容(P) > 網路功能/網際網擄通訊協定第 4 版(TCP/IPv4) > 內容(R) > 一般/`使用下列的DNS伺服器位址(E)` 或 `自動取得DNS伺服器位址(B)`」

## Linux

# GitLab page, DNS, SSL/TLS

兩者取其一, 無法同時存在

- CNAME : `blog.youwillneverknow.com CNAME cool21540125.gitlab.io.`
- A : `blog.youwillneverknow.com A     35.185.44.232`

除非 GitLab admin disable 掉 custom domain 驗證, 否則應有 TXT

- TXT : `_gitlab-pages-verification-code.blog.youwillneverknow.com TXT gitlab-pages-verification-code=e0b85205e0d9b562a7a7e044780652fd`

> If using a DNS A record, you can place the TXT record directly under the domain. If using a DNS CNAME record, the two record types won't co-exist, so you need to place the TXT record in a special subdomain of its own.
> 若使用 A 紀錄, 則直接把 TXT 紀錄 放在 domain 下. (Domain 還有其他用途)
> 若使用 CNAME 紀錄, 則把 TXT 紀錄 放在 subdomain 下. (Domain 專門給 GitLab page)

![AvsCNAME](../img/A與CNAME.png)

## CNAME

| NAME             | TYPE  | VALUE            |
| ---------------- | ----- | ---------------- |
| bar.example.com. | CNAME | foo.example.com. |
| foo.example.com. | A     | 192.0.2.23       |

上表的正確解讀應該是: `bar.example.com` 指向了 `foo.example.com`. 而且 `foo.example.com` 是 `bar.example.com` 的 CNAME!! 經常會被誤會成 bar 是 foo 的 CNAME! CNAME 的意思是 真實名稱, 所以 `foo.example.com` 才是.

- 左側標籤是右側真實名稱的一個同名
- CNAME Record 總是指向另一則 domain
