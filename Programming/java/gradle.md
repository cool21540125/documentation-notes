
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

```ini
### 
org.gradle.console=verbose
# 使用 config 的方式, 等同於下面這行
# gradle build --console=verbose

### 啟用 local build cache
org.gradle.caching=true

### 
```
