
# Install curl

```sh
$# update && apk add curl
```


# Install Docker

```sh
### Install
$ sudo apk add docker

### 讓它開機後直接運行
$ sudo rc-update add docker boot
 * service docker added to runlevel boot

$ sudo addgroup ${USER} docker
$ sudo reboot
```