


```bash
Registry_Server=127.0.0.1:5000
Original_Image=centos:7

### Registry Client1
docker image tag ${Original_Image} ${Registry_Server}/${Original_Image}
docker push ${Registry_Server}/${Original_Image}

### Registry Client2
docker pull ${Registry_Server}/${Original_Image}
```