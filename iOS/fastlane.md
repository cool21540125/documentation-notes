
# Authentication

- fastlane 作為用來 build iOS App 的工具, 需要不時的與 Apple Services 做認證, 驗證方式有底下這些
    - App Store Connect API key (推薦)
        - 官方推薦使用這種方式, 但並非所有的 fastlane action 都有支援就是了
            - [Introduction - App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/)
            - [Spec - App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
        - 此並非官方(Apple)標準
        - 使用 cookie-based web session 做認證
    - 2FA authentication
        - 可再區分成底下的方式
            - Manual verification
                - CI/CD 無法使用
                - 若沒有專門用來取得 2FA 的 Device, 要將 Phone Number 配置到: ~/.fastlane/spaceship/[email]/cookie
                - 把 Phone Number 放到 `~/.fastlane/spaceship/[email]/cookie`, 收簡訊再來輸入 security code
            - Storing a manually verified session using spaceauth
                - 藉由 `fastlane spaceauth -u user@email.com` 生成 login session, 並儲存到環境變數 - `FASTLANE_SESSION`
                    - 得人工定期到機器上頭做 login (敲密碼), 驗證後拿到 `FASTLANE_SESSION='......` (非常大一包)
    - Application-specific passwords
        - 如果要藉由底下方式, 來將 App 上傳到 **App Store Connect** 或 **TetFlight**, 則需要 `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`:
            - `upload_to_app_store` / `deliver` / `upload_to_testflight` / `pilot` / `testflight`
        - 可以到 https://appleid.apple.com/ 建立 `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`
    - Apple ID without 2FA
        - 2019/02 以後都強制得 2FA 了
        - 最原始的方式, 使用 username 及 password 做 cookie-based web session 認證方式


# fastlane tools

- [Fastlane for iOS](https://www.youtube.com/watch?v=N_NwcDO_S_s)

- iOS App developers 遇到的 development process 需要做底下這些任務, 而 fastlane 可協助處理部分任務:
    - [ ] Apple ID
        - 註冊 Apple Developer Program
        - 然後掏錢, 一年 99 USD
    - [ ] Registration
        - register App on **Developer Portal && App Store Connect**
        - fastlane 提供的功能:
            - `produce` : 可用簡單的 command 來協助 register
                - produce creates new iOS apps on both the Apple Developer Portal and AppStore Connect with the minimum required information.
                    - fastlane produce
    - [x] Team setup (多人開發會面臨的問題)
        - Team 每加入一個 Developer, 都會有 Certificates 及 Devices 需提供(provisioned)
        - 協助自動管理 **development certificates** and **provisioning profile**
            - Certificate and Provisioning profile for Code signing
                - signing certificates play an essential role in  Apple's security scheme
                    - Certificate 提供了 Identity
                    - 使用 Certificate 做 app signing
            - Profile 類似於 a group license authorizing a set of known iOS devices to install and run a given iOS app
                - 可以跑 iOS Apps 的 Device 清單啦
        - fastlane 提供的功能
            - 下述的 `match`, `sigh`, `cert`, 都必須要有足夠的權限, 才能使用
                - 由 Developer Portal 控制每個 Developers 的 Apple ID 來控制
                - Developers 的 [Roles](https://developer.apple.com/support/roles/)
            - cert && sigh : first create an iOS code signing certificate and then a provisioning profile for your app if cert succeeded.
                - `cert` : valid certificate & private key 安裝在 local
                    - 建立 iOS code signing certificate
                    - Cert establishes a valid developer portal session, 並檢查 valid iOS certificate, 並確認是否 installed locally
                        - 若無, cert 會 create & store a new private key in my keychin: `$HOME/Library/Keychains/login.keychain-db`
                            - submits a new signing request, 並且 obtains and installs a new Certificate
                - `sigh` : valid provisioning profile 安裝在 local, 配置是否有效
                    - 建立 provisioning profile for App (如果認證過程成功的話)
                    - xcode 使用 `codesign` command-line tool 來簽署 App
                    - fastlane 則是使用 sigh 這個 sub-command 來做處理
                    - NOTE: CI/CD system 不需要安裝 xcode 也可處理 code signing
            - `match` : share one code signing identity across development team 來簡化 code signing setup, 並避免 code signing issue
                - 這東西會做 git 操作
    - [ ] capabilities
        - 像是加入了 capabilities, ex: *MapKit, CloudKit*, xcode 可協助處理 register 這些東東到 **Developer Portal**, 並更新 App's entitlements
    - [x] Testing
        - ex: 使用了 *TestFlight, 其他 3rd ...*, 則需 **distribution profiles**, 預設 xcode 會處理
        - 此外也需要 create/update **code-signed ipa file** && manage testers for your app
            - fastlane 提供的功能:
                - `scan`  : 可在 simulator 或 connected device 做 Testing
                - `gym`
                    - build(建置) && package(打包) iOS App, 生成 **Signed IPA** 或 App File
                    - 用來取代 `shenzhen`
                - `pilot` : 用來方便管理 **Apple's TestFlight**
    - [x] Distribution
        - submit App 到 App Store, 仍有一堆繁瑣任務需要處理...
            - 各種語言的 App metadata 已經提供?
            - 是否符合 Policies?
            - 是否 created && framed screenshots one for every screenshot type multipled by devices?
        - fastlane 提供的功能
            - `snapshot` : generate localized iOS && tvOS screenshots (for 各種 devices && languages) for App Stores
            - `deliver`  : 將上面完成的東西, 做 upload
            - `frameit`  : 可用來放置 gorgeous device frame around iOS screenshots
    - [ ] Sale Apps
        - 自己想辦法
- fastlane 可用來結合上述的這些 tools 到 Script, 稱之為 lanes


# cli-fastlane

```zsh
### basic usage
fastlane $platform $lane


### 傳送 options
fastlane $lane opt1:val1 opt2:val2


### 
```


# lanes

- gym
    - 為 `build_app` 的 alias
- pilot
    - 為 `upload_to_testflight` 的 alias



# dotenv

- 會在 runtime 期間 load 不同的 environemnt variable
    - `.env`        : 自動被 fastlane 載入
    - `.env.secret` : loaded in before_all
    - `.env.ios`    : loaded in before_all in `platform :ios`
    - `.env.mac`    : loaded in before_all in `platform :mac`


# CLI

- `fastlane export_method`
    - 此為 xcodebuild 的 wrapper
    - 下列 options 會基於 archive 而不同
        - app-store
        - ad-hoc
        - package
        - enterprise
        - development (Default)
        - developer-id