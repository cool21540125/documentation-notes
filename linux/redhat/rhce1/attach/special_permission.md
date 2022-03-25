# 特殊權限

## 增加補充 rhce1 - CH6

* 若某些檔案想給 readonly 權限 : 目錄x, 檔案r
* 某些錯誤情況
    - Permission denied : 檔案存取權限不足
    - Operation not permitted : 目前有權使用 `檔案(程式or指令)`, 但此 `檔案(程式or指令)` 無權存取 `其它檔案(程式or指令)`

```sh
# 範例一: 大寫 X
$# chmod -R g+rwX   /home/
# 給 demodir 內所有檔案及資料夾, group 具備下列權限:
# r for 「read a file」 && 「list what the fuck in a dir」
# w for 「edit a file」 && 「create && delete something in a dir」
# X for 「CAN NOT execute a file」 && 「go into a dir」

# 範例二: chgrp 與 chown 的一些替代方式
$# chgrp apache /home/tony/Documents    # chgrp 除了 root 能用, file owner 也可用此指令作用在自己的東西
# 等同於
$# chown :apache /home/tony/Documents   # chown 只有 root 能用
```


# 範例

非Linux開發、維護人員, 最可能遇到的就是 「SUID 指令工具」 && 「SGID 目錄」, 底下以 「SGID 目錄」示範

## 建立掉漆的協作目錄

```sh
### root
### 事前準備
### 確保電腦上「沒有 8787 群組」&&「沒有 12601 使用者」&&「沒有 12602 使用者」&&「沒有/home/teamDir目錄」
groupadd -g 8787 swrd
useradd tony2 -u 12601 -G swrd ; echo 'swrd' | passwd --stdin tony2
useradd howr2 -u 12602 -G swrd ; echo 'swrd' | passwd --stdin howr2

### root
### 正式開始
mkdir /home/teamDir
chown :swrd /home/teamDir
chmod 770 /home/teamDir     # rwxrwx---.    root    swrd
ll -d /home/teamDir

### tony2
sudo -i -u tony2
cd /home/teamDir
cd /
echo 'Tony is NO.1' >> /home/teamDir/t1
exit

### howr2
sudo -i -u howr2
cd /home/teamDir
cd /
echo 'Howard is NO.1' >> /home/teamDir/h1
echo 'ur87' >> /home/teamDir/t1      # 出錯~~ 無權限變動別人的東西
exit

### root
ll /home/teamDir

# 大家都可以到裡面新增檔案了~~~, 但是 tony2 與 howr2 無法更動對方的檔案
```


## 補救掉漆的協作目錄 -> 像樣的協作目錄

```sh
### root
chmod 2770 /home/teamDir
ll -d /home/teamDir         # SGID 後: rwxrws---.   root    swrd

### tony2
sudo -i -u tony2
echo 'Tony is still NO.1' >> /home/teamDir/t2
exit

### howr2
sudo -i -u howr2
echo 'You are 878787' >> /home/teamDir/t2
exit

### root
ll /home/teamDir         # 比較裡面的東西
cat /home/teamDir/t2

### root
### 事後清除
userdel -r howr2
userdel -r tony2
groupdel swrd
rm -rf /home/teamDir
```
