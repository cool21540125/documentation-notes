
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



### 
```


# gradle Environment Variables

```bash

```
