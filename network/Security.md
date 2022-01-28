
# 網站安全

- [讓我們來談談 CSRF](https://blog.techbridge.cc/2017/02/25/csrf-introduction/) 深奧卻淺顯易懂
- [從防禦認識CSRF](https://www.ithome.com.tw/voice/115822) not yet
- [19. Cross Site Request Forgery (CSRF)](https://docs.spring.io/spring-security/site/docs/current/reference/html/csrf.html) not yet


# 密碼學

## Encode 編碼

ex: UTF-8, ASCII, Unicode, base64

不具備任何加密效果!!

- Base64
    - 常用於處理文字格式
- URL Encode
    - Percent-encoding(百分號編碼)的通稱
    - 常用於將表單傳遞資料作轉換
- Huffman Coding
    - 用於無損資料壓縮的熵編碼(權編碼)演算法
    - 用於 gzip, bzip2, pkzip


## Hash 雜湊

- 主要分為 `Hash Function` && `Hash Table`
- 雜湊並非加密!!
- 相同的 Hash Function, 不管輸入啥, 輸出長度都固定
- 輸入不同東西, 結果可能相同. 此稱為 `Hash Collision`
- 無法逆推 (想像成把水果丟到果汁機...)
- Algorithms
    - MD5 : 產生 128 bits (16 bytes)
    - SHA-1 : 產生 160 bits (20 bytes)
    - SHA-256 : 產生 256 bits (32 bytes)
    - SHA-512 : 產生 512 bits (64 bytes)


## Encrypt 加密
