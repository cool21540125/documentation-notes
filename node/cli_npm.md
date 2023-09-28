
- [What is the difference between "npm install" and "npm ci"?](https://stackoverflow.com/questions/52499617/what-is-the-difference-between-npm-install-and-npm-ci)

```bash
### 更新 package.json 到 latest, 並據此更新 package-lock.json, 再依照 package-lock.json 內容來安裝 pkgs
npm update


### 不修改 package.json, 但使用它來更新 package-lock.json, 再依照 package-lock.json 內容來安裝 pkgs
npm install
npm i


### 依照 package-lock.json 內容來安裝 pkgs
npm ci
# 會搭配使用 package.json 來做安裝驗證, 如果有 mismatched versions, 則會噴錯
# 適合用來做 CI/CD, testing 等等
```

- npm 不管是哪種安裝方式, 都依照 `package-lock.json` 來做安裝
    - `npm update`  : 　更新 `package.json`, 　更新 `package-lock.json`, 安裝套件
    - `npm install` : 不更動 `package.json`, 　更新 `package-lock.json`, 安裝套件
    - `npm ci`      : 不更動 `package.json`, 不更新 `package-lock.json`, 安裝套件


```bash
### 2023.09 的現在, versioning
npm -v
#8.19.4


### 安裝 prd 套件, 放入 dependencies
npm i xxx
npm i --save xxx
# npm v5.0.0 以後, 預設已經是 --save


### 安裝 dev 套件, 放入 devDependencies
npm i --save-dev xxx
npm i -D xxx


### 
```
