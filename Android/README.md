
- 2022/Q4 開始研究 Android 這東東
- [App Bundles: Building your first app bundle - MAD Skills](https://www.youtube.com/watch?v=IPLhLu0kvYw&t=1s)

# Terms

- aab, Android App Bundle



# environment

- ANDROID_HOME **Deprecated**
    - 建議改用 ANDROID_SDK_ROOT
- ANDROID_SDK_ROOT
    - Installation directory of Android SDK package.
        - ex: /usr/local/android-ndk
    ```sh
    # for mac
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
    ```
- ANDROID_NDK_ROOT
- ANDROID_SDK_HOME
    ```sh
    export ANDROID_SDK_HOME="$HOME/.android"
    ```
- ANDROID_EMULATOR_HOME
- ANDROID_AVD_HOME
    - Location of AVD-specific data files.
    - Android Studio 可以用來 RUN 的 Device 設定檔, 會放在這裡面
        ```sh
        export ANDROID_AVD_HOME="$HOME/.android/avd"

        ls -l $ANDROID_AVD_HOME
        # Pixel_3a_API_33_x86_64.ini   config file
        # Pixel_3a_API_33_x86_64.avd/  Directory
        ```
- JDK_HOME && JAVA_HOME
    - Android Studio 裡頭似乎內建了 Java8 (Android Studio Dolphin | 2021.3.1 Patch 1)
    - 可設置此變數來指定額外的 Java 版本的樣子


# 安裝套件

```sh
### 不解釋
$# sdkmanager --list
$# sdkmanager --list_installed

### 首次使用時, 先同意吧~
$# yes | sdkmanager --licenses > /dev/null


### 安裝 build tools
$# sdkmanager "build-tools;33.0.0"
# 之後會有互動式詢問, 選「y」
# 會把 build-tools/33.0.0 安裝在 $ANDROID_SDK_ROOT 裡頭

### 安裝 cmake
$# sdkmanager "cmake;3.10.2.4988404"
```


# Android build

```sh
### Gradle Version
$# ./gradlew -v

------------------------------------------------------------
Gradle 6.5.1
------------------------------------------------------------

Build time:   2020-06-30 06:32:47 UTC
Revision:     66bc713f7169626a7f0134bf452abde51550ea0a

Kotlin:       1.3.72
Groovy:       2.5.11
Ant:          Apache Ant(TM) version 1.10.7 compiled on September 1 2019
JVM:          11.0.16.1 (Homebrew 11.0.16.1+0)
OS:           Mac OS X 12.6.1 x86_64


### 建置 Release 版
$# ./gradlew bundle


### 產出 apk 或 aab
$# ./gradlew bundleDebug       # outputs/bundle/debug
$# ./gradlew bundleRelease     # outputs/bundle/release
# 等同於 
# java \
#   -Xdock:name=Gradle \
#   -Xdock:icon=${APP_ROOT}/build/android/proj/media/gradle.icns \
#   -Dorg.gradle.appname=gradlew \
#   -classpath ${APP_ROOT}/build/android/proj/gradle/wrapper/gradle-wrapper.jar \
#   org.gradle.wrapper.GradleWrapperMain \
#   bundleRelease

$# ./gradlew assembleDebug    # outputs/apk/debug
$# ./gradlew assembleRelease  # outputs/apk/release


$# apksigner sign --ks ${KeyStore} ${APK}
```
