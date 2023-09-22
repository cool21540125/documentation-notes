# 資安相關

- 2019/08/08
- [DNSSEC安全技術簡介](http://www.cc.ntu.edu.tw/chinese/epaper/0022/20120920_2206.html)


# 雜湊函式 hash function

> `hash_value = hash_function(Data)`, hash_value 可能會重複, 重複的機率取決於它的長度

常見的雜湊函式:

- RSA 公司的 MD2, MD4, MD5
- NIST 公司的 SHA


## MD5, Message-Digest Algorithm 5

- md5(any object) -> 128 bits (32 個 16 進位字符)


# 金鑰加密 && 數位簽章

Example: A 寄信給 B

- A 根據 信件內容 使用 Hash Function 來產生一組 HashValue, 接著使用自己的 PrivateKey 對剛剛產生的 HashValue 加密, 產生的東西叫做 `Digital Signature (數位簽章)`, 並將該簽名附加到信件末尾, 寄出去給 B

- B 收到後, 使用 A 的 PublicKey 來解開 Digital Signature (還原出 A 產生的 HashValue)
    - 成功 -> 用以確認東西是來自 A
    - 失敗 -> 東西不是 A 寄過來的

- 接著, B 使用相同的 Hash Function 來計算 A 的信件內容
    - B HashValue == A HashValue -> 資料沒經過竄改
    - B HashValue != A HashValue -> 資料被竄改了!!
