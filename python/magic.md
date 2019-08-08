# Python dunder methods

## `__init__`
- 建構式
- 用途為: binding(繫結)


## `__name__`
- 類別方法 (實例無此方法)
- 回傳 類別的名稱

```python
### __name__ 用途
class C:
    pass

C.__name__ # 'C'
```


## `__doc__`
- 抓 類別說明 (instance or class 皆可使用)

```python
### __doc__ 用途
class C:
    '''沒有用的東西'''
    pass

print(C.__doc__) # 沒有用的東西
```


## `__bases__`
- 回傳 父類別們 (tuple)

```python
### __bases__ 用途
class Traffic:
    pass

class Car(Traffic):
    pass

Car.__bases__ # (__main__.Traffic,)
```


## `__set__`
- 類別物件內, 若有定義這個, 則稱此類別為 `覆寫式描述器(overriding descriptor)` or `data descriptor(資料描述器)`(比較老舊的稱呼)


## `__get__`
- 類別物件內, 若有定義此方法, 則此類別稱為 `descriptor(描述器)`
- 若為唯讀(無 `__set__`), 則稱為 `nonoverriding descriptor(非覆寫式描述器)` or `nondata descriptor(非資料描述器)`


## `__getattribute__`
- 對 `實體屬性` 的所有參考, 都會通過 `特殊方法 __getattribute__`
- 調用 `instance` 屬性 or 方法 之前, 都會先來調用 `__getattribute__`
- 由 `object` 實作 `__getattribute__`

```python
### __getattribute__ 用途: 覆寫子類別, 隱藏繼承而來的類別屬性, 讓子類別成為不再具有 append 的 list
class listNoAppend(list):
    def __getattribute__(self, name):
        if name == 'append':
            raise AttributeError(name)
        return list.__getattribute__(self, name)


a = [1, 2, 3, 4, 888]
uu = listNoAppend(a)
print(uu) # [1, 2, 3, 4, 888]
uu.pop()
print(uu) # [1, 2, 3, 4]
uu.append(888) # ..... AttributeError: append
```


## `__dict__`
- 其他屬性映射, 回傳 dictionary ((C1範例))

```python
### C1範例
class C1:
    x = 23
    C1.y = 8
    def m1(self):
        C1.z = 5
        w=6

print(C1.__dict__)
"""
{
    '__module__': '__main__',
    'x': 23,
    'm1': <function C1.m1 at 0x7fa35243f1e0>,
    '__dict__': <attribute '__dict__' of 'C1' objects>,
    '__weakref__': <attribute '__weakref__' of 'C1' objects>,
    '__doc__': None
}
"""
```

