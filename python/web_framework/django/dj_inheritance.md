
# User

```py
class User(AbstractUser):
    """dj auth/models.py"""
```


# Permission

```py

```


# Model

```py
class Model(metaclass=ModelBase):
    """
    dj models/base.py
    """
```


# Serializer

```py
class Field:
    """drf fields.py"""

class BaseSerializer(Field):
    """
    drf serializers.py
    - many_init(): 處理 ListSerializer 的 many=True
    - data() prop
    - errors() prop
    - validated_data() prop
    """

class ListSerializer(BaseSerializer):
    """drf serializers.py"""

class SerializerMetaclass(type):
    """drf serializers.py"""

class Serializer(BaseSerializer, metaclass=SerializerMetaclass):
    """
    drf serializers.py
    - fields() prop
    - get_fields()
    - get_validators()
    - get_value()
    - validate()
    """

class ModelSerializer(Serializer):
    """
    drf serializers.py
    - create()
    - update()
    - get_fields()
    - get_validators()
    """

class HyperlinkedModelSerializer(ModelSerializer):
    """
    drf serializers.py
    - 使用 hyperlinked relationships 取代 pk relationships ( 'url' 取代 'id' field)
    """
```


# View

```py
class View:
    """
    dj base.py
    - 定義基本的 HTTP methods
    - as_view()
    """
    
class APIView(View):
    """
    drf views.py
    - many policy_classes attrs
    - permission()
    - authentication()
    - throttle()
    - context()
    - content_negotation()
    - dispatch()
    """

class ViewSetMixin:
    """
    drf viewsets.py
    - as_view(): to create a concrete view binding the 'GET' and 'POST' methods to the 'list' and 'create' actions...
        - view = MyViewSet.as_view({'get': 'list', 'post': 'create'})
    """

class ViewSet(ViewSetMixin, views.APIView):
    """
    drf viewsets.py
    """
```


# mixin

```py

```


# Request

```py

```


# Response

```py
class HttpResponseBase:
    """
    dj response.py
    - 別鳥這個就是了
    - 負責 組/解 HTTP Response
    """

class HttpResponse(HttpResponseBase):
    """
    dj response.py
    - 處理 string content
    """

class SimpleTemplateResponse(HttpResponse):
    """
    dj response.py
    """

class Response(SimpleTemplateResponse):
    """
    drf response.py
    - 可將 HttpResponse 依照各種 media types 做處理
    """
```


# 
