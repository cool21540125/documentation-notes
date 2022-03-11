# Hugo

## Template 屬於 `content` 和 `presentation` 之中介橋樑

- Template 的 rules 規則: 哪些內容要被發布, 發布到哪裡, 如何 render 到 HTML
- Template 藉由 css 規範 presentation

Template 分為 3 類:
- single
- list
- partial


## 折疊清單

```hugo
{{< expand "折疊" >}}
內容
{{< /expand >}}
```

## gist

```hugo
{{ < gist username gist_id >}}
```

## [footnotes](https://themes.gohugo.io//theme/hugo-theme-jane/post/doc-footnote-preview/)

設定頁尾註解 `[^footnote]`

`[^footnote]': 頁尾會出現這個

## underline

```hugo
<u>底限</u>
```

<u>UnderScore</u>


# notice

```hugo
{{< notice XXX Caption >}}
Context
{{< /XXX >}}
```

XX 有 :
- note
- info
- warning
- tip

