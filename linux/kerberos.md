# kerberos

- 2018/10/16

kerberos 是一種 `計算機網路的授權協議`, 採用 `對稱金鑰` 進行加密

在整個 kerberos 系統中, 需要一部 可被大家信賴的第三方, 稱之為 `金鑰分發中心(Key Distribution Center, KDC)`, 所有的主機都需要加入至 kerberos 服務內. 並且跟 kerberos KDC 要求 一個票據(ticket), 作為日後與此資料加密的依據.

KDC 也提供 `身分驗證(Authentication Server, AS)` 的功能


