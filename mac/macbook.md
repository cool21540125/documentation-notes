# printscreen

- command + shift + 3 > 擷取畫面 (printscreen)
- command + shift + 4 > 截取部分畫面
- command + shift + . > 顯示/隱藏 隱藏檔


# zsh

```bash
### 從 Catalina 不知道哪版開始, default login shell 改為 zsh
### ~/.bash_profile -> ~/.zshrc
alias ls='ls -G'
alias la='ls -aG'
alias ll='ls -lG'
alias lla='ls -alG'

alias dpsa='docker ps -a'
alias dc='docker-compose'

PS1='[\u@\h \W]\$ '  # bash
PS1='[%n@%m %1~]$ '  # zsh
# 更多 zsh 的教學可參考這邊: https://wiki.gentoo.org/wiki/Zsh/Guide 
# 或者直接參考 /etc/zshrc 裡面的寫法
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
