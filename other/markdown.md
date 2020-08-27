# Markdown
- 2018/08/07

# 大綱 h1

## h2
### h3
#### h4
##### h5
###### h6



# 條列說明 (無序)

- 早餐
- 午餐
- 晚餐



# 條列說明 (有序)

1. 早餐
2. 午餐
3. 晚餐



# 分段 && 重點標示

這邊是第一段...為了 **衝版面**, 來個自我介紹好了, 我是 Tony, 是個孳生工程師, 我的工作從前端html, javascript做一些簡單的UI, jQuery AJAX, 到後端的 Flask 玩過一陣子, 最近在摸 Django, 弄了一堆 87的 RestFramework, 以為這樣就沒了嗎, 你太小看我了, 我還有弄 MongoDB Query, MySQL 一堆 subquery, join, 還有資料庫備份 && 資料庫規劃 ...&@^%@#  還有阿還有阿~~~ Linux也摸了一陣子, 好了, 廢話太多, 總之我要說, `分段的話, 底下要多空一行.`

下一段了哦~~, 如果不小心說錯話, 可以偷偷的槓掉, 像是說, ~~我是個大帥哥~~, 打完有種想哭的感覺...

一個段落裏頭, 有再多再多再多再多再多再多再多`再多的空白鍵                                                                                                               都會被當成只有一個`, 相信智商暴表的你知道我意思.

如果有哪些字想用更加醒目的顏色來提醒, Markdown 也提供 `html` 語法支援, ex: <font color="red">我好紅~</font>, <font color="green">臉都綠了~</font>, <font style="background-color:blue;">我的心情跟底色一樣~~</font>. 但是~~~ Github 沒有 部分HTML的語法支援, ex: `<font color="red">xxx</font>`, 故看不到顏色效果



# 引文

> `這邊是亂數假文, 沒有彩蛋, 請勿浪費時間!` 兩的成國……年選的分心考，持外今，快心了地！費標工的結太做真：機行愛地；上系所如清友上明於。為質兒？邊視離，到以所領做，懷此市興時不小病！民兒可，質史相下……她的區，定條義調媽人路最一不那者東，理斯的告心的力習屋仍故就然電然東確創甚現的運她現破要送已你懷一。



# 表格

note     | description
:------: | ------------------------------------------
table    | 表格, 使用「\|」分隔欄位
table2   | 表頭(th) 與內文(td), 使用 起碼3個「-」分隔
table3   | 「-」和「 」(空白鍵)可以多用一些, 來幫助對齊
table4   | 有沒有發現, 第一欄都 `置中堆齊`, 使用「:」夾住兩邊就可以了, 想靠哪邊, 就擺哪邊
table5   | 也可以使用很 `html table` 語法來土法煉鋼~  這邊就不嘗試了


# 畫線

使用三個以上的「-」 或是三個以上的「*」, ex:

減減減分隔線~~~

--------------------------------------


星星分隔線~~

*************************************************



# 程式碼

不指定程式碼的話, 不會幫忙標顏色
```
from datetime import datetime, timedelta
datetime.now()
```

Javascript
```js
var ctx = document.getElementById('myChart').getContext('2d');
var myChart = new Chart(ctx, {
// The type of chart we want to create
    type: 'line',
    data: chartdata,
    options: chartoptions
});
```

Python
```py
from datetime import datetime, timedelta
datetime.now()
```

也可以使用「縮排」來當成程式碼, 但一樣無法辨識是哪種語言

    from datetime import datetime, timedelta
    datetime.now()



# table of contents, TOC 摺疊清單

## 1. 使用預設名稱

<details>

- Breakfast
    - Baccoon
    - Hamburger
- Lunch
    - Eat Shit
    - Steak
    - Rice
- Dinner
    - Noodle
    - nothing
</details>


## 2. 自訂名稱

<details>
    <summary>名字可以自己打~~</summary>

- Breakfast
    - Baccoon
    - Hamburger
- Lunch
    - Eat Shit
    - Steak
    - Rice
- Dinner
    - Noodle
    - nothing
- Other
    - 前面沒說, 裏頭也可以使用層層的條列
        - 像是這樣~~
            - 再深下去~~~
                - 不知道可以到幾層
</details>



# 文內超連結

- [本文內超連結 (要回去的「#」的地方, 不能是特定名字 && 不能有 空白)](#h2)



# 超連結

[點我到Google](https://www.google.com.tw)

超連結也可以把圖片塞進來, 如下圖:

![看到這些字的話, 代表圖片掛了](../img/git01.jpg)
