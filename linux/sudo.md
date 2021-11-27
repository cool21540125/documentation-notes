# sudo 這東西

- 2019/12/25

常常看到 Linux 有人使用

- `su -`
- `sudo su -`
- `sudo -i`

第一個, `su -`, 是讓 **目前使用者**, 切換為 root (但是需要 root 的密碼)

另外 2 個差在哪邊?

```bash
$# sudo su -
$# echo $PATH
/root/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#         ↑↑↑↑↑↑↑↑↑↑↑↑↑↑                 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑  疑!? 為啥多了一個?

$# sudo -i
$# echo $PATH
/root/bin:/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin
#         ↑↑↑↑↑↑↑↑↑↑↑↑↑↑

$# cat ~/.bash_profile
# ---------- 部分內容如下 ----------
PYTHON_HOME=/usr/local/bin

PATH=${HOME}/bin:${PYTHON_HOME}:${PATH}

export PATH
# ---------- 部分內容如上 ----------
```

經過累人的肉眼比對後, 發現 `sudo su -` 裏頭有 2 個 `/usr/local/bin`

至於為啥, 原理是啥, 有其他差異? 目前還不曉得..... 將來有空再補
