#!/bin/bash
exit 0

## 排版後寫回該檔案 (老實說用途不大, 僅做排版 & 格式檢查, 不做合法性驗證)
alloy fmt -w config.alloy

## 改完配置後 reload
ALLOY_ENDPOINT=http://localhost:12345
curl -X POST ${ALLOY_ENDPOINT}/-/reload

## 