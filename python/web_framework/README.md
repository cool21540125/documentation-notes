# Web Application(App Server)(Python 觀點)

- 2018/05/18
- [What is the point of uWSGI?
](https://stackoverflow.com/questions/38601440/what-is-the-point-of-uwsgi?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
- [python server比較](https://www.digitalocean.com/community/tutorials/django-server-comparison-the-development-server-mod_wsgi-uwsgi-and-gunicorn)
- [寫得很棒的Web Server/App Server - RoR觀點](https://github.com/evenchange4/blog/blob/master/source/_posts/Ruby/2013-07-04-server.md)
- [我覺得寫得很棒的 WSGI解說](https://github.com/uranusjr/django-tutorial-for-programmers/blob/1.8/02-how-does-django-work.md)
- [gunicorn 組態(中文)](https://tw.saowen.com/a/c85254c32f134b6654a89b72971d5d5ace28d99d63c29f134639d5010141bd4e)



# 3個很容易搞混的名詞比較 (大小寫)

- uWSGI: 
    - 純 Python 的 App/HTTP Server
    - 無法在 Windows 上運行(或許安裝一堆有的沒的以後就可以跑了?)
- WSGI, Web Server Gateway Interface
    - 規範了 Web Server 與 Web APP 溝通的介面
    - 像是 Flask, Django, ... 都自帶 WSGI Server, 但是效能都不好
        - 因此 prod env, 都不建議使用
        - 可使用像是 wsgi, nginx, ...
    - 使用 python 開發 web 框架 所需要遵照的協議
    - 除非要自行開發 Python Web Framework, 不然不需要太鑽研這個
- uwsgi
    - python base App Server 與 Web Server 溝通的協定

![比較表](../../img/wsgi.jpg)
[圖片來源在這 - 我覺得他寫的很棒~](https://www.rapospectre.com/blog/31)



```mermaid
graph LR
webServer[Web Server] -- uwsgi 協議 --- appServer[App Server]
appServer             -- WSGI 協議  --- webApp[Web Framework]
```

---------------------------
## WSGI

`Flask`、`Django` 本質上就是一個 `WSGI Application`, 用來與 `WSGI Server` 溝通. 當 `WSGI Server` 被啟動時, 會進行以下動作:

1. 初始化
2. Start Loop, 等候 request
3. 等到請求後, 呼叫 `WSGI Application`, 開始一系列處理, 並 send response
4. back to Loop
5. repeat 2-4 ~~到死為止~~



```sh
alias rr='nginx -s reload; systemctl restart ww'
alias ss='systemctl status ww'
```