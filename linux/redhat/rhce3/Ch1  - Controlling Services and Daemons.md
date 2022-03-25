# Ch1  - Controlling Services and Daemons

## 開機介面模式

Target            | Purpose
----------------- | --------------------
graphical.target  | 圖形化桌面環境
multi-user.target | 白底黑字專業阿宅介面
rescue.target     | (進階)救援用
emergency.target  | (進階)救援用

```sh
systemctl get-default

### 立刻啟用
systemctl isolate multi-user.target
systemctl isolate graphical.target

### 重開機後啟用
systemctl set-default multi-user.target
systemctl set-default graphical.target
```
