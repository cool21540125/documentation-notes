# printscreen

- command + shift + 3 > 擷取畫面 (printscreen)
- command + shift + 4 > 截取部分畫面
- command + shift + . > 顯示/隱藏 隱藏檔


# CLI

```zsh
### TIMEFMT 設定 time 評估資源好用的輸出
$# TIMEFMT+='  max RSS %M'
$# time xxx
YOUR_COMMAND  1.63s user 1.20s system 47% cpu 6.012 total  max RSS 385852
# user time : 1.2s
# sys  time : 47%
# total     : 6.012s
# 增加 Memory Usage
```


# Other

```bash
### 這在幹嘛的我忘了
==> openssl
A CA file has been bootstrapped using certificates from the SystemRoots
keychain. To add additional certificates (e.g. the certificates added in
the System keychain), place .pem files in
  /usr/local/etc/openssl/certs

and run
  /usr/local/opt/openssl/bin/c_rehash

openssl is keg-only, which means it was not symlinked into /usr/local,
because Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries.

If you need to have openssl first in your PATH run:
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile

For compilers to find openssl you may need to set:
  export LDFLAGS="-L/usr/local/opt/openssl/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl/include"
```


```bash
### 自簽憑證位置
/Users/tony/Library/Application Support/Certificate Authority
```


## ACL

- 2020/10/26
- [Set default directory and file permissions](https://discussions.apple.com/thread/4805409)

macbook 至今依舊沒有 Linux 上的 `setfacl` 功能,  可用底下方式代替

```zsh
chmod -R +a "group:GroupName allow read,write,append,readattr,writeattr,readextattr,writeextattr" /Path-To-Shared-Directory

chmod -R +a "group:tony allow read,write,append,readattr,writeattr,readextattr,writeextattr" /var/log
chmod  -R +a 'tony allow write,delete,file_inherit,directory_inherit,add_subdirectory' /var/log
```