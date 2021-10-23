# Gitea

- [env寫法](https://github.com/go-gitea/gitea/tree/master/contrib/environment-to-ini)
- [組態主檔說明](https://docs.gitea.io/en-us/config-cheat-sheet/)
- [擺脫控制，用 Docker 自建 Gitea (Gogs) 線上代碼協作平臺](https://asaba.sakuragawa.moe/2018/06/%E6%93%BA%E8%84%AB%E6%8E%A7%E5%88%B6%EF%BC%8C%E7%94%A8-docker-%E8%87%AA%E5%BB%BA-gitea-gogs-%E7%B7%9A%E4%B8%8A%E4%BB%A3%E7%A2%BC%E5%8D%94%E4%BD%9C%E5%B9%B3%E8%87%BA/)
- 2021/03/03, latest = 1.13.2
- 2021/05/20, latest = 1.14.2


# SELinux Problem

- [Gitea with SELinux](https://github.com/gidcs/gitea-selinux-policy/blob/master/README.md)

```bash
### 基本上用這個就可以了 (如果有用 nginx 反代 80 -> 3000)
semanage port -a -t http_port_t -p tcp 3000
```