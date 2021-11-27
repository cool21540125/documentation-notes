# cmatrix

## 讓 terminal 出現像是駭客任務那樣的畫面

- 2020/03/19
- https://thornelabs.net/posts/linux-install-cmatrix-from-rpm-deb-xz-or-source.html
- https://blog.csdn.net/youmatterhsp/article/details/82889560
- http://blog.itist.tw/2016/08/easter-eggs-or-funny-commands-with-linux-shell.html


```bash
$# wget https://jaist.dl.sourceforge.net/project/cmatrix/cmatrix/1.2a/cmatrix-1.2a.tar.gz
$# tar xf cmatrix-1.2a.tar.gz
$# cd cmatrix-1.2a
$# yum install -y ncurses-deve  # 這個好像沒用...
$# ./configure && make && make install

$# ls -l /usr/local/bin/cmatrix
-rwxr-xr-x. 1 root root 39192 Mar 18 06:57 /usr/local/bin/cmatrix

$# ln -s /usr/local/bin/cmatrix /usr/local/bin/hack
#         ^^^^^ 可以連到這裡             ^^^^^ 藉由這裡

### Usage
$# hack
```
