
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


### 
kubectl get nodes -o custom-columns=NODE:.metadata.name,CPU:.status.capacity.cpu


### 
kubectl get nodes --sort-by .status.capacity.cpu
```
