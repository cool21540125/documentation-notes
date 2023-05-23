
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
