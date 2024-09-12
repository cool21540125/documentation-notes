### 新增 分佈點的清除緩存紀錄 (就是清除緩存啦)
DISTRITUTION_ID=ERBFUWQGKAOHZ
aws cloudfront create-invalidation \
  --distribution-id ${DISTRITUTION_ID} \
  --paths "/test"

### 列出 清除緩存的紀錄
aws cloudfront list-invalidations \
  --distribution-id ${DISTRITUTION_ID}

### 查詢 某次緩存的清除紀錄
Invalidation_ID=OOOOOOOO
aws cloudfront get-invalidation \
  --distribution-id ${DISTRITUTION_ID} \
  --id ${Invalidation_ID}
