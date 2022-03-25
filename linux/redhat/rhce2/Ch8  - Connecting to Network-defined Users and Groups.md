# Ch8  - Connecting to Network-defined Users and Groups




## LDAP - 輕型目錄存取協定(Lightweight Directory Access Protocol)

- 2018/11/02

LDAP目錄的條目(entry)由屬性(attribute)的一個聚集組成, 並由一個唯一性的名字參照, 即 **專有名稱(distinguished name, DN)**.

ex: DN 為 「cn=tony,ou=swrd,ou=swrd,dc=pome,dc=com」

- dc: document component
- ou: organization unit

```
                    LDAP
                ------------------
                | dc=pome,dc=com |
                ------------------
                /               \
        -----------             ------------
        | ou=swrd |             | ou=sales |
        -----------             ------------
        /           \
--------------      -----------
| ou=manager |      | ou=swrd |
--------------      -----------
                    /       \
            -----------     -----------
            | cn=tony |     | cn=andy |
            -----------     -----------
            + UID
            + GID
            + comment
            + Password
```