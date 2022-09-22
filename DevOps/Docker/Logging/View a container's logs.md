# View logs for a container or service

- 使用 `docker logs` 來查看 `running Container` 的運行資訊
- 使用 `docker service logs` 查看 `running Containers in a Service` 的運行資訊
- 以下統稱 `docker logs`
- `docker logs` 執行後, Unix 底下會開啟 3 條 I/O streams, 分別是 `STDIN`, `STDOUT`, `STDERR`.
    - 預設 `docker logs` 會顯示出 `STDOUT` & `STDERR`
- 如果已經把 log 寫入到 外部檔案, Log Server, DB, ... 則 `docker logs` 其實就沒啥用處了
- 參考 [Nginx](https://hub.docker.com/_/nginx) 及 [httpd](https://hub.docker.com/_/httpd), 提供了不同的 Logging 方式
    - nginx 透過建立底下軟連結, 參考 [Dockerfile](https://github.com/nginxinc/docker-nginx/blob/8921999083def7ba43a06fabd5f80e4406651353/mainline/jessie/Dockerfile#L21-L23)
        - from `/var/log/nginx/access.log` to `/dev/stdout`
        - from `/var/log/nginx/error.log` to `/dev/stderr`
    - httpd 直接改寫組態, 參考 [Dockerfile](https://github.com/docker-library/httpd/blob/b13054c7de5c74bbaa6d595dbe38969e6d4f860c/2.2/Dockerfile#L72-L75)
        - normal output -> `/proc/self/fd/1` (也就是 `STDOUT`)
        - error output -> `/proc/self/fd/2` (也就是 `STDERR`)

關於 I/O Redirection, 可參考官方的 [Chapter 20. I/O Redirection](https://tldp.org/LDP/abs/html/io-redirection.html)