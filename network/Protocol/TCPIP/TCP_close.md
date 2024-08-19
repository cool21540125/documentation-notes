
- https://learn.microsoft.com/en-us/answers/questions/230227/time-wait-from-netstat
- https://distributedsystemsblog.com/posts/tcp-connection-terminate/

---

```mermaid
flowchart TD

estab[ESTABLISHED]
close[CLOSED]

subgraph passive["passive close"]

    close_wait[CLOSE_WAIT]
    last[LAST_ACK]

    close_wait -- "appl: close \n send: FIN" --> last
end

subgraph active["active close"]

    fin1[FIN_WAIT_1]
    fin2[FIN_WAIT_2]
    wait[TIME_WAIT]
    closing[CLOSING]

    fin1 -- "recv: FIN \n send: ACK"     --> closing -- "recv: ACK \n send: -"   --> wait
    fin1 -- "recv: ACK \n send: -"       --> fin2    -- "recv: FIN \n send: ACK" --> wait
    fin1 -- "recv: FIN+ACK \n send: ACK" --> wait

end

estab -- "recv: FIN \n send: ACK" --> close_wait
estab -- "appl: close \n send: FIN" --> fin1

last -- "recv: ACK \n send: -" --> close
wait -- "2 MSL timeout" --> close

```

---

- Server `accept()` 之後 => `LISTEN`
- Client `發送 SYN` 之後 => `SYN_SENT`
- Server `接收 SYN` 之後, `發送 SYN, ACK` => `LISTEN`
- Client `接收 SYN, ACK` 之後, `發送 ACK` => `ESTABLISHED`
- Server `接收 ACK` 之後 => `ESTABLISHED`
