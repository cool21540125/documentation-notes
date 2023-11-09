
# gradle

- [Youtube-Gradle Tutorial](https://www.youtube.com/watch?v=gKPMKRnnbXU)
- gradle project 設定檔: `settings.gradle`
- gradle submodule 設定檔: `build.gradle`
- gradle 生成 Android apk/aab
	- apk 用 assemble  (release 成 apk)
	- bundle 用 bundle (release 成 aab)
- gradle 內建的階段:
	- productFlavors, ex:
		- tw
		- en
	- buildTypes (會變成小駝峰)
		- develop
		- debug
		- release
	- 組合起來就有
		- gradle assembleTwDevelop
		- gradle assembleEwDebug
		- gradle assembleTwRelease
		- gradle assembleEwDevelop
		- gradle assembleTwDebug
		- gradle assembleEwRelease


# build.gradle

```gradle
### plugins 的使用
plugins {
    application
    `maven-publish`
}
# application : 可以讓 CLI 操作 gradle 的樣子?
# maven-publish : `gradle :app:tasks` 可看到多了 Publishing tasks, 可用來 publish 到 maven
```


# gradle.properties

```property
### 
org.gradle.console=verbose
# 使用 config 的方式, 等同於下面這行
# gradle build --console=verbose


### 啟用 local build cache
org.gradle.caching=true


### 

```


# gradle CLI

```bash
gradle -v
# 8.2.1


### 安裝 gradle wrapper
gradle wrapper
# 必須要有 settings.gradle


### 驗證是否為合格的 gradle project (有這東西?)



### 清空 build/
gradle clean


###
gradle test
gradle test -p $SUBMODULE


### 
gradle build


### 更新 gradle 的依賴
gradle --refresh-dependencies


### 列出 app 這個 subproject 的 transitive dependency(傳遞依賴)
gradle :app:dependencies



### 使用 Build Scan 做依賴性及專案掃描 (可找出專案的深度分析)
gradle build --scan
# CLI 首次使用需要敲 yes 授權同意, 造訪網頁時, 還需要做 email 認證


### dru run
gradle build --dry-run
# 或
gradle build -m
```

- gradle build 的 **Outcome Labels**
	- `UP-TO-DATE`
		- 使用 **incremental build** and **were not re-run**
	- `SKIPPED`
		- 你明確告知 gradle 不要 build 此 subproject/module
	- `FROM-CACHE`
		- 因無異動, 直接 **from the local build cache**
	- `NO-SOURCE`
		- 本次要 build 的 subproject/module 不存在
	- `(無 Label)`
		- 則 the task was newly executed by Gradle (locally)
