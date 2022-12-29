

```bash
$# kubectl proxy \
    --reject-paths="^/api/v1/replicationcontrollers" \
    --port=8001 \
    --v=2
# 建立一個 kube proxy 跑在 8001
# 拒絕讓用戶訪問 RC 的 API

$# kubectl proxy \
    --accept-hosts="^localhost$,^127"
```