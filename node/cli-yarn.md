
- [What is the closest to `npm ci` in yarn](https://stackoverflow.com/questions/58482655/what-is-the-closest-to-npm-ci-in-yarn)

```bash
### 
yarn --frozen-lockfile
# 不要產生 lockfile
# 如果需要 update, 則自動 fail
# ---> 優點: 版本可鎖住
# ---> 缺點: CI/CD pipeline 使用此方式, 可能會有失敗的風險

yarn --pure-lockfile
# 不要產生 lockfile
# ---> 優點: 版本可鎖住
# ---> 缺點: CI/CD pipeline 使用此方式, 可能會有失敗的風險

yarn --no-lockfile


```
