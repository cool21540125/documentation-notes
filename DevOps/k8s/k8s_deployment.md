

## Deployment of stateful and stateless applications

- stateless - `type: Deployment`
- stateful - `type: StatefulSet`
    - sticky identity for each pod
        - ex: 每個 Pods 分別為 ID-0, ID-1, ID-2
        - 彼此之間 not interchangeable
    - 萬一 Pod 掛了, restart 以後, identity 也不會改變
    - 可以用 MySQL, write to Master, Read from Slaves 的角度來思考會比較好理解~
