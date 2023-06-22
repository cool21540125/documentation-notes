
# JSON Path - Criteria

```json
[
    12, 43, 23, 12, 56, 80, 66, 78
]
```

- 找 List 使用 `$[ xxx ]`
    - `$[ Check if each item in the list > 40 ]`
        - `Check if` 使用 `?( )`
    - `$[ ?( each item in the list > 40 ) ]`
        - `each item in the list` 使用 `@`
    - `$[ $( @ > 40 ) ]`
        - `@ == 40`
        - `@ != 40`
        - `@ in [40, 50, 33]`
        - `@ nin [80, 49, 38]`

```bash
### 
kubectl get nodes -o jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}'


### 
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.capacity.cpu}{"\n"}{end}'
# FOR EACH NODE
#    PRINT NODE NAME \t PRINT CPU COUNT \n
# END FOR


### 
kubectl get nodes -o custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu


### 排序
kubectl get nodes --sort-by .status.capacity.cpu



### 其他
kubectl config view --kubeconfig=/root/my-kube-config -o jsonpath='{.users.*.name}'
kubectl get nodes -o jsonpath='{range .items[*]}{.status}'

# get all pv & sort by size
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage  --sort-by .spec.capacity.storage

```
