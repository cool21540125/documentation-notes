# GPG Key

- 2020/01/20
- [Signing commits with GPG](https://gitlab.com/help/user/project/repository/gpg_signed_commits/index.md)

Gitlab 也可使用 GPG Key 認證登入

先安裝 [GnuPG](https://www.gnupg.org/download/index.html)

```powershell
### 1. Windows 有安裝 choco 的話, 直接使用
> choco install gnupg
```

安裝好之後, 就可以來產生 gpg key 了

```bash
### 1. 產生 private/public key pair (若有 gpg2 的話, 盡量使用 gpg2 來取代 gpg)
$# gpg --full-gen-key  # 指令視環境不同, 可能為 「gpg --gen-key」
Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1  # 2. 選擇自己偏好的密碼演算方式

RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096  # 3. 密碼複雜度
Requested keysize is 4096 bits

Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 2y  # 4. 密碼有效期間 (原本預設為 0)
Key does not expire at all

Is this correct? (y/N) y  # 5. 不解釋

GnuPG needs to construct a user ID to identify your key.

Real name: demo21540125@gmail.com  # 6. 不解釋
Email address: demo21540125@gmail.com  # 7. 不解釋
Comment:
You selected this USER-ID:
    "Mr. Robot <your_email>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O  # 8. 確認後再 OK, 打錯則回去改

### 9. 列出 GPG private key                   ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
$# gpg --list-secret-keys --keyid-format LONG demo21540125@gmail.com
sec   rsa4096/XXXXXXXXXXXXXXXX 2020-01-20 [SC] [expires: 2022-01-19]
      WWWWWWWWWWWWWWWWWWWWWWWWXXXXXXXXXXXXXXXX
uid                 [ultimate] demo21540125@gmail.com (Demo) <demo21540125@gmail.com>
ssb   rsa4096/OOOOOOOOOOOOOOOO 2020-01-20 [E] [expires: 2022-01-19]
# 上面的 XXXXXXXXXXXXXXXX 為 GPG key ID

### 10. 用 private key 產生 public key (把上面的 XXXXXXXXXXXXXXXX 弄來這邊)
$# gpg --armor --export XXXXXXXXXXXXXXXX
# ↓ 底下整包都是 public key ↓
-----BEGIN PGP PUBLIC KEY BLOCK-----

~~~ 不給你看 ~~~
-----END PGP PUBLIC KEY BLOCK-----
# ↑ 上面整包都是 public key ↑
# 貼到 Gitlab (不要框到空白)
```
