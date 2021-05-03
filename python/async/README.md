# asynchronous 非同步架構

如果一支程式經常 存取磁碟 (CPU總是得等待磁碟回覆才能接著作事), 那表示這支程式是 `I/O bound` 的程式碼. 改善效率的解法, 把此程式改成 `非同步 (async)`, 改完後, 此程式就變成 `非阻斷 (nonblocking)`, 可以大幅增進效能. (`非同步(async) 架構`, 有時候也被稱為 `事件驅動(event-driven) 架構`)

非同步的架構分為三類:
1. 多工 (multiplexed async architecture) - 像是多線程, 稱為 平行 Parallel
2. 事件 (callback-based)
3. 協程 (coroutine-based) - 併行 Concurrent

## 1. 多工 multiplexed

程式碼會不斷追蹤 `I/O channels`, 如果程式處理中的 `I/O` 還沒完成, 那麼程式就進入了 `block`, 直到 I/O channel 完成, 才會喚醒 `blocking wait`, 程式才會繼續作後續的工作.

Python有許多 低階模組 支援多工的非同步架構, 但建議使用高階的 `selectors模組`



## 2. 事件 event



## 3. 協程 coroutine





# 執行緒 thread

- 一個 **行程(process)** 是 `執行中的程式 的 一個實體`.
- os 確保 processes 之間不互相干擾
- process 之間想互相通訊, 需透過 `行程間通訊(inter-process communication, IPC)` 的機制來做安排
- process 之間, 可透過 file/DB 來做溝通




---
---
---

# 並行 與 平行
## threading moduel - 多執行緒
- [threading](https://docs.python.org/3/library/threading.html)
- python 具有 [GIL](https://itw01.com/2TQBELW.html), 所以`少用它來做密集運算`

```py
import threading
class Haha(threading.Thread):
    def __init__(self, a):
        pass
    def run(self):  # ~原始的業務邏輯~
        pass

Haha(5).start() # ~執行緒邏輯~
```


### 阻斷
遇到 Block時, 自動讓出執行權


### Daemon 執行緒
```py
threading.Thread(target=None, daemon=True) # 此時為背景執行
```


### 安插執行續
```py
tb = threading.Thread(target=do_me_first)
tb.start()
tb.join()           # 插隊囉~~
# or tb.join(5)     # 給你插隊 5秒鐘做事
```


### 停止執行緒
```py
class Some:
    def gg(self):   # 執行緒 停止, 重啟, 暫停 的邏輯, 依需求實作
        pass    # 自行實作

    def run(self):
        pass

s = Some()
t = threading.Thread(target=s.run)
t.start()
# ...
s.gg()   # 停止執行續(注意是 s 而非 t)
```


# uvloop: Blazing fast Python networking

- 2019/04/22
- [uvloop: Blazing fast Python networking](https://magic.io/blog/uvloop-blazing-fast-python-networking/)
- `event loop` 為 `asyncio` 的核心
- `uvloop` 基於 `libuv` 用 Cython 來寫的, 只能在 **nix** && python >= 3.5 上運行
    - `libuv` 為跨平台的異步 I/O lib, 也被 nodejs 所用
- `uvloop` 實作所有 asyncio event loop APIs


# Transports && Protocols

- transport && protocols 共同定義了使用 `network I/O` 及 `interprocess I/O` 的 抽象介面
- transport && protocol 永遠都是 1:1 的關係
- protocol 呼叫 transport 方法來 `send` data; transport 調用 protocol 方法來 `pass` 它所收到的 data
-

## @ Transports

- How to transmit bytes
- Abstraction for socket

## @ Protocols

- Which bytes to transmit(When to transmit)
- Abstraction for application



# asyncio
- https://docs.python.org/3.7/library/asyncio-task.html

執行 asyncio 的 3 種方式:
1. asyncio.run(<async fn>)
2. 在 async fn 裏頭, 去做 `await <async fn>()`
3. 在 async fn 裏頭, 去做 `task = asyncio.create_task(<async fn>())` && `await task`

主要的 3 種 awaitable 物件有: **coroutines**, **Tasks**, **Futures**



```py
awaitable asyncio.gather(*aws, loop=None, return_exceptions=False)
# return_exceptions
# False -> 第一個錯誤發生時, 立即傳播到 gather() 所等候的 task, 但其餘 aws 不會被中斷
# True  -> 發生例外的任務, 將與正常的任務視為一樣並且回傳.
```


## 比較 coroutine function 與 generator function

- `coro fn` yield `coro obj`
- `g fn` yield `g obj`

v3.5 以後, 改用 
- `async def` 來建立 `coro`
- `async with` 來建立 `async context manager`
- `async for`(用來迭代 非同步的Iterable) 來建立 `async iteration`

```py
# 下面兩者相同
### v3.4前
@asyncio.coroutine
def delayed_result(delay, result):
    """
    call this will get a coro object (sleep delay second, then return 23)
    asyncio.iscoroutinefunction(delayed_result)  # True
    asyncio.iscoroutine(delayed_result)  # True
    """
    yield from asyncio.sleep(delay)
    return result

### v3.5後
async def delayed_result(delay, result):
    """
    也可以在此 coro fn 上頭一樣加上 @asyncio.coroutine, 但真的沒必要也不建議
    async def 實作的 coro fn, 裡面不可以有 yield
    """
    await asyncio.sleep(delay)
    return result
```
