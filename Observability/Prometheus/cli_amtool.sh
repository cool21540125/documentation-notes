#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

### Version
amtool --version
#amtool, version 0.28.1 (branch: HEAD, revision: b2099eaa2c9ebc25edb26517cb9c732738e93910)
#  build user:       root@b7f54ff1a00f
#  build date:       20250307-15:03:03
#  go version:       go1.23.7
#  platform:         linux/arm64
#  tags:             netgo

### alertmanager 配置檔最基本的檢測
amtool check-config alertmanager.yml

###
amtool config routes --config.file alertmanager.yml
# 此指令效果等同於 https://prometheus.io/webtools/alerting/routing-tree-editor

### 如果不曉得 config 在哪邊, 也可以直接針對 alertmanager endpoint 做檢測
amtool config routes --alertmanager.url http://localhost:9093

### 可以針對 alert label 做 Check, 看看會落入到哪個(些) route(s)
amtool config routes test --config.file alertmanager.yml {env=prod,team=devops}
#fallthrough

### (似乎是測試用) 用來將 alert.json 套用到 template 來查看 alerts
amtool template render \
  --template.glob '*.tmpl' \
  --template.text '{{ template "descriptions" . }}' \
  --template.data alert_data.json
#[FIRING] - CPU is elevated on api1 for >30m
#[FIRING] - CPU is elevated on api3 for >30m
#[RESOLVED] - CPU is elevated on api2 for >30m

###
