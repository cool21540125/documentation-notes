# maven

- [Youtube-Maven Tutorial](https://www.youtube.com/watch?v=Xatr8AZLOsE)
- maven 專案設定檔: `pom.xml`

- 預設的 `default location for Maven local repository` 會是在 : `$HOME/.m2`
  - 發送到 Maven Repository 的東西大概都這些:
    - One or more artifacts
    - The Gradle Module Metadata
    - The Maven POM file

# maven Environment Variables

```bash
export MAVEN_HOME=xxx  # 網路上一堆大大建議不要再用這個了, 直接 PATH 指向 maven/bin
export MAVEN_OPTS="-Xmx1048m -Xms256m -XX:MaxPermSize=312M"
```
