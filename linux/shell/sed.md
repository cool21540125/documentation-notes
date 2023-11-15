
需要先確認 `sed` 指令是 GUN 版本還是 BSD 版本

兩者不一樣!!!

```bash
DOMAIN=
sed -i "s/\/etc\/nginx\/conf.d\/cert/\/etc\/certs\/${DOMAIN}/g" example.com.conf
```