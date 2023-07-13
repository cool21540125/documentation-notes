# Selenium 爬蟲

## 使用Selenium來解決javascript動態產生網頁產生的爬網難題

### python3安裝完以後,開始安裝selenium
- 2017/09/23
- [SeleniumHQ](http://www.seleniumhq.org/)
- [Selenium Client Driver¶](https://seleniumhq.github.io/selenium/docs/api/py/)
- [webdriver 顯式等待 vs 隱式等待](https://selenium-python-zh.readthedocs.io/en/latest/waits.html)


1. 下載Firefox Selenium Client Driver
```
$ cd ~
$ mkdir bin
$ cd bin
$ wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz
$ tar zxf geckodriver-v0.18.0-linux64.tar.gz
```
2 設定環境變數
```
$ vi .bashrc
```

新增下列指令到文件最後
```sh
export SELENIUM_HOME=~/
export PATH=$PATH:$SELENIUM_HOME/bin
```

3. 上網去下載 Selenium Firefox Driver (Chrome Driver同理)

```
下載並解壓縮後, 得到「geckodriver」這樣一個東西, 把他放到上述第2點所設定的環境變數資料夾底下
```

4. 安裝python3的相依套件
```sh
$ pip install -U selenium
```


5. 開始使用
```python
from selenium import webdriver
web = webdriver.Firefox('Path to Web Driver')
web.get('https://google.com.tw')
# selenium操作~~
web.close()
```
