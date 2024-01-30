# HTML基本

- [HTML Head](https://www.w3schools.com/html/html_head.asp)
- 每個 HTML Element都有 `id`
- 每個 Element都有 `style` 及 `className`


```
DOM
 |- Elements
 |- Text Nodes
```



# head - viewport

設定 `可視區` = `設備寬度` (初始大小為1.0). ex: 手機瀏覽時, 假設有圖片, 圖片可以以較佳的寬度呈現

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```



# head - meta - http-equiv

每隔30秒頁面重新刷新

```html
<meta http-equiv="refresh" content="30">
```



# head - meta - http-equiv

- [歷史包袱-與IE的相容模式](http://blog.darkthread.net/post-2016-05-26-x-ua-compatible-setting.aspx)

讓網頁與 `IE Edge` 相容

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge">
```



# body - 內文拼字檢查

- html5 屬性: `contenteditable` 可作拼字檢查
- [W3C Example](https://www.w3schools.com/tags/tryit.asp?filename=tryhtml5_global_contenteditable)

```html
<div id="editor" contenteditable>
    Click to edit
</div>
```


## Attribute v.s. Property

```html
<input type="text" value="tony" id="demo" />

<script>
    var a = document.getElementById('demo');
    a.getAttribute('value');    // tony
    a.value();                  // tony
    // tony

    // 但如果在 網頁上, 把輸入框的值改成 chou 以後...
    a.getAttribute('value');    // tony
    a.value();                  // chou

    // attribut -> HTML
    // property -> DOM
</script>
```


```html
<a href="" target="_blank" rel="noreferrer noopener"></a>
<!-- 務必加上 rel="noreferrer noopener" -->
<!-- 防止網頁使用 window.opener 來操作原有頁面 -->
```