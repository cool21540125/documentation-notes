# NPM

- npm 不管是哪種安裝方式, 都遵循 `package-lock.json` 來做安裝

## .npmrc

- `.npmrc` 定義了 `npm` 在 runtime 的行為. 也就是 **runtime configuration**
- 層級:
  - Project Level $(./.npmrc)
  - User Level $(~/.npmrc)
  - Global Level $($Prefix/etc/npmrc)
- npm builtin config file $(/path/to/npm/npmrc)
