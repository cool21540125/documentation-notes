#!/bin/bash
exit 0
#
# 這東西開源版本被閹割過, 沒辦法架設 multi-nodes (好像是這樣子)
# 調整彈性也幾乎沒有, 僅能做個人 lab
# 因此把 charts 下載下來也沒意義 (不過好像也沒辦法下載??) 總之這樣做也沒意義就對了
# 所以姑且就只抓 values
#
# 似乎也沒有 repo add (起碼我找不到...)
#
## ------------------------ n8n ------------------------
# https://artifacthub.io/packages/helm/open-8gears/n8n

mkdir n8n && cd n8n
helm show values oci://8gears.container-registry.com/library/n8n > default-values.yaml
cp default-values.yaml values.yaml
# 編輯 values.yaml
helm upgrade --install my-n8n oci://8gears.container-registry.com/library/n8n -f values.yaml

# Case2. 先下載完整 Charts, 修改後再 install (可完整控制, 但複雜)
# helm pull oci://8gears.container-registry.com/library/n8n --version 1.0.0 --untar
# 可以拿到一整包完整的 n8n 資料夾, 裡頭會有完整的 Chart 資訊
