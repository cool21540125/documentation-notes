# Hashing

- hashing 將 明碼 利用 演算法/雜湊函數(hash function), 轉換成 hash value
  - hash value 理論上獨一無二, 但仍可藉由 collision attack 拼湊出 非法解
  - hash function 可用來作 checksum
  - hashing 為 **不可逆**
- 目前 `MD5` 及 `SHA1` 已知為不安全
- hashing 演算法家族:
  - sha
    - sha1
    - sha2
      - Sum256, Sum512
    - sha3
      - Sum512
  - bcrypt

# Encryption

## symmetric encryption, 對稱加密法

- 加密方法:
  - 區塊加密法:
    - DES, 資料加密標準
      - 年代久遠, 不過容易遭到破解, 因此 DES 逐漸被 AES 取代
    - AES, 進階加密標準

## asymmetric encryption, 非對稱加密法/公鑰加密法

- 加密方法:
  - RSA, Rivest-Shamir-Adleman
    - RSA-OAEP, 最優非對稱加密填充
  - DSA, digital signature, 數位簽章算法

## TLS, 傳輸層安全協定
