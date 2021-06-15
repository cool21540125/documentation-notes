# LDAP 與 AD 相關

- [ADAM, Active Directory, LDAP, ADFS, Identity](https://stackoverflow.com/questions/4619911/adam-active-directory-ldap-adfs-identity)


# 名詞

- AD          : Active Directory, Window Server 用來管理 Windows 網域資訊的元件.
- DIT         : Directory Information Tree, 目錄資訊樹. 就是把所有使用者攤開掛在樹上時, 看起來的那種畫面 (可以看到大家所處的分支位置)
- OU, CN, DC  : 由右而左 為 大類到小類, 是 LDAP 用來查詢 特定使用者 的分類表示法, 有點類似 SQL 的 where
- ADAM        : Active Directory Application Mode
- AD LDS user : 是一種 




```bash
yum install -y openldap-clients
# Installed:
#   - openldap-clients 2.4.44-23.el7_9
# Dependencies:
#   - openldap         2.4.44-23.el7_9
#   - openldap-devel   2.4.44-23.el7_9
```

