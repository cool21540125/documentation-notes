
# Authorization

- RBAC, Role Based Access Control
    - role-based security
    - 比較有規模的大型組織 or 成熟一點的服務, 基本上都用這種方式, 來給予 user(role) 必要的權限
    - 用以表彰 system 授予了哪些必要的 Roles 給特定 Users.
        - Users 只能執行 Roles 被授予的權限
- ABAC, Attribute-based access control
    - 可針對特定 user 做更加細粒度的權限控制
- ACL, Access Control List
    - 廣泛地使用在 DAC systems
- Discretionary Access Control, DAC, 自主存取控制
- Mandatory Access Control, MAC, 強制存取控制


### RBAC vs ABAC

> While RBAC relies on pre-defined roles, ABAC is more dynamic and uses relation-based access control. You can use RBAC to determine access controls with broad strokes, while ABAC offers more granularity. For example, an RBAC system grants access to all managers, but an ABAC policy will only grant access to managers that are in the financial department. ABAC executes a more complex search, which requires more processing power and time, so you should only resort to ABAC when RBAC is insufficient.
