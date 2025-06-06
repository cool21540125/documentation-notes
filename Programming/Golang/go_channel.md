| Channel 的行為 | 讀取                                | 寫入                   | 關閉                   |
| -------------- | ----------------------------------- | ---------------------- | ---------------------- |
| 無緩衝(開啟)   | 暫停, 直到有東西被寫入              | 暫停, 直到有東西被讀取 | 可運作                 |
| 無緩衝(關閉)   | return 零值 (使用 `v,ok` )          | panic                  | panic                  |
| 有緩衝(開啟)   | Buffer 是空的就暫停                 | Buffer 已滿就暫停      | 可運作, 其餘的值仍存在 |
| 有緩衝(關閉)   | return Buffer 剩餘值 (使用 `v,ok` ) | panic                  | panic                  |
| nil            | 永遠停擺                            | 永遠停擺               | panic                  |

`ch := make(chan int)`

channel 的 zero value 為 `nil`

```go
// goroutine 只從 channel 讀取
ch <- chan int

// goroutine 只寫入 channel
ch chan <- int

// 建立 buffer channel
ch := make(chan int, 10)

len(ch)  // channel buffer 有多少值
cap(ch)  // channel buffer 有多大 (緩衝區無法變更)

// 如果 channel 已經關閉, 再次寫入會噴 panic; 再次讀取則不會有事
close(ch)
```
