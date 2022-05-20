# 非同步 Async

- 2018/05/30
- [同步 && 異步 - 非常白話文](https://medium.com/@hyWang/%E9%9D%9E%E5%90%8C%E6%AD%A5-asynchronous-%E8%88%87%E5%90%8C%E6%AD%A5-synchronous-%E7%9A%84%E5%B7%AE%E7%95%B0-c7f99b9a298a)
- [非同步 解說(文謅謅)](https://www.ithome.com.tw/node/74544)



# 名詞定義

- Concurrency(共時, 併發) : Dealing with lots of things at once
- Parallelism(平行) : Doing        lots of things at once



# 異步框架模型

- 阻塞式單一行程
- 阻塞式多行程
- 阻塞式多行程多執行緒
- 非阻塞式事件驅動
- 非阻塞式共時



# 程式特性 - Python 觀點

- [Greenlet Vs. Threads](https://stackoverflow.com/questions/15556718/greenlet-vs-threads)
- [gevent程序員指南](http://hhkbp2.github.io/gevent-tutorial/)


```py
import gevent

def oo():
    print('最先執行oo')
    gevent.sleep(0)
    print('xx剛剛也睡著了,所以又回來oo')

def xx():
    print('oo剛剛睡著了,所以跑來xx')
    gevent.sleep(0)
    print('oo結束了,最後換我')

gevent.joinall([
    gevent.spawn(oo),
    gevent.spawn(xx),
])

# 最先執行oo
# oo剛剛睡著了,所以跑來xx
# xx剛剛也睡著了,所以又回來oo
# oo結束了,最後換我
```


# 程式特性 - Go 觀點

- [Concurrency vs Parallelism](https://blog.golang.org/concurrency-is-not-parallelism)



# 程式特性 - Nodejs 觀點




