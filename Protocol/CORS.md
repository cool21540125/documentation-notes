# 了解 Sec-Fetch-Site

本文為 [Understanding "same-site" and "same-origin"](https://web.dev/same-site-same-origin/) 的筆記

`same-site` 與 `same-origin`, 像是在底下的情境, 經常的被混淆:

- context of page transition (頁面轉換)
- iframes
- fetch() request
- cookies
- opening popups
- embeded resources

-------------------------------

## cross-origin

Cross-Origin Resource Sharing, CORS - Access Control Allow Origin

```
https://www.example.com:443
^^^^^   ^^^^^^^^^^^^^^^ ^^^
scheme  hostname        port
```

Same Origin 定義: 有相同的 scheme + hostname

下列 URL 與 https://www.example.com 範例比較:

- https://www.evil.com:443      : cross-origin: different domains
- https://example.com:443       : cross-origin: different subdomains
- https://login.example.com:443 : cross-origin: different subdomains
- http://www.example.com:443    : cross-origin: different schemes
- https://www.example.com:80    : cross-origin: different ports
- https://www.example.com:443   : same-origin: exact match
- https://www.example.com       : same-origin: implicit port number (443) matches


## cross-site

```
            eTLD & site
            vvvvvvvvvvv
https://www.example.com:443
        ^^^^^^^^^^^^^^^
             eTLD+1
```

- https://www.evil.com:443      : cross-site: different domains
- https://login.example.com:443 : same-site: different subdomains don't matter
- http://www.example.com:443    : same-site: different schemes don't matter
- https://www.example.com:80    : same-site: different ports don't matter
- https://www.example.com:443   : same-site: exact match
- https://www.example.com       : same-site: ports don't matter

---------------------------------------------------

IMPORTANT: 底下 2 者的觀念, 是隨著時代演進逐漸轉變:

- 早期 same-site 定義: 不同的 scheme + 相同的 site. ex: *example.com*           => 稱之為 `scheme-less same-site`
- 將來 same-site 定義: 相同的 scheme + 相同的 site. ex: *https* + *example.com* => 稱之為 `schemeful-same-site`

---------------------------------------------------

- https://www.evil.com:443      : cross-site: different domains
- https://login.example.com:443 : schemeful same-site: different subdomains don't matter
- http://www.example.com:443    : cross-site: different schemes
- https://www.example.com:80    : schemeful same-site: different ports don't matter
- https://www.example.com:443   : schemeful same-site: exact match
- https://www.example.com       : schemeful same-site: ports don't matter


## 由 HTTP header 識別

早期由 Chrome 實作, 但後來陸續有其他廠商跟進. 使用 `Sec-Fetc-Site`, 有如下結果:

- `cross-site`
- `same-site`
- `same-origin`
- `none`

如此便可透過此 HTTP header, 來辨識

------------------------------------------

`strict-origin-when-cross-origin` 可查看 https://site-one-dot-referrer-demo-280711.ey.r.appspot.com/stuff/detail?tag=red&p=p2


## Cross Origin Request

### Step1

```mermaid
flowchart LR;

origin["Origin \n https://www.example.com"];
cross["Cross Origin \n https://www.other.com"];

Browser --> origin;
Browser -- Preflight Request --> cross;
```
```bash
### Preflight Request 內容
OPTIONS /
Host: www.other.com
Origin: https://www.example.com
```


### Step2

```mermaid
flowchart LR;

cross["Cross Origin \n https://www.other.com"];

Browser -- Preflight Request --> cross;
cross -- Preflight Response --> Browser;
```
```bash
### Preflight Response 內容 
Access-Control-Allow-Origin: https://www.example.com
Access-Control-Allow-Methods: GET, PUT, DELETE
```


### Step3

```mermaid
flowchart LR;

cross["Cross Origin \n https://www.other.com"];
Browser -- Request --> cross;
```
```bash
### Request 內容 
GET /
Host: www.other.com
Origin: https://www.example.com
```