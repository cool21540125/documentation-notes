


```bash
DOMAIN=
sed -i "s/\/etc\/nginx\/conf.d\/cert/\/etc\/certs\/${DOMAIN}/g" example.com.conf
```