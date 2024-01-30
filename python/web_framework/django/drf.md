- 2018/08/12 v3.8.2
- 2020/03/30 v3.11.0
- 2020/12/20 v3.12.2


## Request && Response

DRF 的 Request 擴展了 Django 的 HttpRequest.

```bash
### Request
request.POST  # Only headers from data. 只能用在 POST
request.data  # Handles arbitrary data. 適用於 POST, PUT, PATCH

### Response
return Response(data)  # 會依照 client 指定的 content type 來做 render

```

### status code

`from rest_framework import status` 可處理 status_code


## Request parsing

用 `req.data` 代替 `req.POST`, `req.FILES`

用 `req.query_params` 代替 `req.GET`

`req.parsers` (通常用不到... 別理他)



# Browser enhancements

drf 對於 瀏覽器的 web form 的 `PUT`, `PATCH`, `DELETE` 有提供額外方法:

`.content_type`(而非 .META.get('HTTP_CONTENT_TYPE')) 取出 media_type

`.stream` 取出 stream



# 繼承架構

```
Serializer
    ↑
ModelSerializer
    ↑
HyperlinkedModelSerializer
```

## `ModelSerializer` v.s. Serializer

使用 serializers.ModelSerializer 取代 serializers.Serializer (兩者皆為 Form 的概念), 而 ModelSerializer 直接給定 Meta
1. 直接套用 models 定義好的 schema 來當作 metadata
2. 預設實作了簡單版的 create() 及 update()



# Models

```py
from django.db import models

class XX(models.Model):

    class Meta:
        ordering = ('a',)                   # 依照欄位排序
        managed = True                      # 允許 Django 建立, 修改, 刪除 Table
        db_table = 'tbl_name'               # Table Name
        unique_together = (('x', 'y'),)     # 唯一值組合
```



# Serializers

```py
# 很容易跟 Models 搞混成一團 @@...
from rest_framework import serializers

class SnippetSerializer(serializers.ModelSerializer):

    class Meta:     # 改成 ModelSerializer 需要定義 Meta (資料結構吧?!)
        model = Snippet
        fields = '__all__'
```



# [Authentication](http://www.django-rest-framework.org/api-guide/authentication/)

settings.py
```py
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.BasicAuthentication',            # 預設啟用
        'rest_framework.authentication.SessionAuthentication',          # 預設啟用
        'rest_framework.authentication.TokenAuthentication',            #
        'rest_framework.authentication.RemoteUserAuthentication',       # Web Server 代理 App Server 作認證
        'oauth2_provider.contrib.rest_framework.OAuth2Authentication',  # 3rd 認證 - OAuth2
        'rest_framework_digestauth.authentication.DigestAuthentication' # 3rd 認證 - Digest
    )
}
```

> 接收請求時, 進到 view 處理前, 就會先做 `authentication(認證)` (優先於 `permission` && `throttling checks` && `any check`)


Authentication | request.user | request.auth
-------------- | ------------ | ------------------------------------------
Basic          | Django User  | None
Session        | Django User  | None
Token          | Django User  | rest_framework.authtoken.models.Token
RemoteUser     | Django User  | None


# 序列化 && 反序列化

序列化

> ex: Django Model: User 的實例 um, 可透過自行定義 UserSerializer, 使用 `us = UserSerializer(um); us.data`, 拿到 `python native type 的 User`, 此動作稱為 marshalling (*translated the model instance into Python native datatypes*) ;
> 爾後再將此 dict/OrderedDict -> 網路通用格式動作, 稱之為 serialize: 使用 `bu = rest_framework.renders.JSONRenderer().render(us.data)` -> **bytes(json)** (我把它理解成, 長得很像 json 的 bytes)

反序列化

> 透過 `strm = io.BytesIO(bu); data = JSONParser().parse(strm)` 可反序列化回 Python native datatypes(dict)



# noums

- throttle : [限流](https://www.django-rest-framework.org/api-guide/throttling/)