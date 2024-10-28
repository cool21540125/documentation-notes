- 參考: [https://itkb.ddns.net/如何在 ubuntu-20-04 中‧設定 ipsec-vpn 伺服器/](https://itkb.ddns.net/%E5%A6%82%E4%BD%95%E5%9C%A8ubuntu-20-04%E4%B8%AD%E2%80%A7%E8%A8%AD%E5%AE%9Aipsec-vpn%E4%BC%BA%E6%9C%8D%E5%99%A8/)
- 參考: https://github.com/hwdsl2/setup-ipsec-vpn
  - 管理 VPN 用戶 https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/manage-users-zh.md
- 參考: https://blog.yowko.com/install-ipsec-vpn-server-on-ubuntu/

## VPN 安裝配置

```bash
### 設定時區
sudo timedatectl set-timezone Asia/Taipei

### install IPsec VPN
wget https://get.vpnsetup.net -O vpn.sh && sudo sh vpn.sh
# SG 需要過白 `UDP 500` 及 `UDP 4500` - 才能撥通 VPN
# SG 需要過白 `TCP 22` - 才能當作跳板訪問內網

# 安裝完後會有底下資訊:
# Server IP
# IPsec PSK
# Username
# Password

## =============== 修改 IPsec/L2TP 的 帳密 ===============
sudo cat /etc/ppp/chap-secrets
# --------------- 內容如下 ---------------
"(這個是Username)" l2tpd "(這個是Password)" *
# --------------- 內容如上 ---------------
# 此檔案為 VPN accounts 的檔案

### 重啟服務
sudo systemctl restart xl2tpd
systemctl status xl2tpd

## =============== 修改 IPsec/L2TP 的 PSK ===============
sudo cat /etc/ipsec.secrets
# --------------- 內容如下 ---------------
%any  %any  : PSK "(這個是IPsec PSK)"
# --------------- 內容如上 ---------------
# 此檔案內的欄位為 `IPsec PSK`

sudo systemctl restart ipsec
systemctl status ipsec
```
