
# function scope

```js
function printA() {}
function printB() {}

module.exports.ppA = printA;
// printA 匯出, 為 public function
// printB 未匯出, 為 private function
```


# REPL 環境

```js
const process = require('process');
// 等同於腳本內的 import 'process';
```
