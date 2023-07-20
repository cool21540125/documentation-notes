
# 套件管理

- 版本號 `major.minor.patch`
    - major : 有 breaking change
    - minor : 有 new feature (不破壞已有功能)
    - patch : BugFix
- 依賴包版本表示, ex:
    - `~1.2.3` : 匹配 minor 的依賴. 適用於 `1.2.x`, 但不包含 `1.3.0` 以上
    - `^4.5.6` : 匹配 major 的依賴. 適用於 `4.x.x`, 但不包含 `5.0.0` 以上
    - `*7.8.9` : 匹配 *     的依賴. 不管　 `x.x.x`, 全都接受
- npm 升級套件
    - `npm update`
    - `npm i`
    - `npm ci`
