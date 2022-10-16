# VSCode Debugging

# 變數

- `${workspaceFolder}` : 此專案的 根目錄, 即 `proj/`
- `${file}` : Editor 內要執行的程式碼 的 檔案名稱


# .vscode/launch.json

```jsonc
// python
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flask DEBUG Run",
            "type": "python",
            "request": "launch",
            "program": "main.py",               // 直接指定執行目標
            "program": "${file}",               // 執行目前的檔案
            "console": "internalConsole",
            "justMyCode": true,
            "env": {
                "PYTHONPATH":"${workspaceFolder}:${workspaceFolder}/devops:${workspaceFolder}/devops/service:"
                // 上面這邊放 PYTHONPATH
            },
            "args": ["runserver", "--noreload", "--nothreading"],  // 用來丟 python xxxx 的這些參數
        }
    ]
}
```


# Other

### pythonPath 用來 debug 的 Python 直譯器位置

- 2022/10 的現在, 不知道還能不能使用

```js
// 關於 pythonPath, 也可以使用特定的字詞, 來規範不同平台使用的 直譯器
"osx": {    // Mac平台
    "pythonPath": "^\"\\${env:SPARK_HOME}/bin/spark-submit\""
},
"windows": {
    "pythonPath": "^\"\\${env:SPARK_HOME}/bin/spark-submit.cmd\""
},
"linux": {
    "pythonPath": "^\"\\${env:SPARK_HOME}/bin/spark-submit\""
},
// Note: 上面的「\"」, 為 路徑內含有「 」的必要附加設定
// 迷之音: Windows 哪時候有 pyspark了...??
```


### cwd 說明

`cwd` 就是 debugger 的 `current working directory`, 也就是 相對於要 debug 的程式碼 的 base folder (乾~ 很不白話)

例如: 專案根目錄 為 `proj/`, 專案架構如下

```
proj/
    py_code/app.py
    data/salaries.csv
```

現在要對 `app.py` 作 debug, salaries.csv 的相對路徑會因為 `cwd` 而有所不同

cwd                             | 相對於 data file 的路徑
------------------------------- | --------------------------
Omitted or ${workspaceFolder}   | data/salaries.csv
${workspaceFolder}/py_code      | ../data/salaries.csv
${workspaceFolder}/data         | salaries.csv


### debugOptions

可用的選項有 `["RedirectOutput", "DebugStdLib", "Django", "Sudo", "Pyramid", "BreakOnSystemExitZero", "IgnoreDjangoTemplateWarnings"]`

- RedirectOutput : (預設) 讓 Debugger 印出所有 output 到 VS Code debug output window. 若捨略此設定, 所有 程式輸出 將不會出現. 但如果 console 為 `integratedTerminal` 或為 `externalTerminal` 時, 此選可省略.
- DebugStdLib : 會跑進去 StdLibrary 裡頭...(沒必要啦!!)
- Django : 啟用 debugging feature specific 到 Django
- Sudo : 得與 `"console": "externalTerminal"` 搭配使用, 則允許 debugging apps that require elevation
- Pyramid : 
- BreakOnSystemExitZero : (不明)
- IgnoreDjangoTemplateWarnings : (不明)


### env (看不太懂...)

原文 : Sets optional environment variables for the debugger process beyond system environment variables, which the debugger always inherits.


### envFile (看不太懂...)

原文 : Optional path to a file that contains environment variable definitions. See [Configuring Python environments - environment variable definitions file](https://code.visualstudio.com/docs/python/environments#_environment-variable-definitions-file).


# Remote debugging (有點猛)

可在 host, 執行 沒有安裝 VS Code 的 remote 端的程式

## prerequest
1. 兩部電腦 : make sure that identical source code is available (看不懂..)
2. Mac & Linux: `pip3 install ptvsd==3.0.0` ; Windows: `pip install ptvsd==3.0.0`
3. Remote : 開放 port 給 debugger 使用
4. Remote : 遠端電腦放這個
```py
import ptvsd

# Allow other computers to attach to ptvsd at this IP address and port, using the secret
ptvsd.enable_attach("my_secret", address = ('1.2.3.4', 3000))

# Pause the program until a remote debugger is attached
ptvsd.wait_for_attach()
```
5. 
6. 
7. 
8. 
9. 
10. 
11. 

乾~~ 我放棄了... 總共有 11個步驟 ㄇㄉ


## Debugging over SSH (to remote)

因為某些特定因素, 可能也得作加密連線, 來作遠端 debug... (內容 pass)
