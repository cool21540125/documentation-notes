
- Provisioning profiles 或 provisioningProfiles
    - 一組設定檔, 主要用途:
        - 確保正確的簽署 App
            - iOS App 要上架到 **App Store** 都需要 sign
                - private key 簽署
                - public key / Certificate 驗證 App 開發者身份
        - 確保 App 能夠安全地在指定的裝置上運行
    - 包含了底下的資訊:
        - Team ID
            - iOS Development Team 的 pk
            - **Developer Portal** 及 **membership section** 可看到
        - Bundle ID / Bundle Identifier
            - 每個 iOS App 都需要這個 pk
            - 通常為 reverse domain name
            - 需要用這東西, 才能在 **AppStore Connect** 去 create App
        - App ID / App Identifier
            - 一般來說, 此為 **team ID** 與 **bundle ID** 所組成
        - Device ID
            - 每個 iOS Device 的 pk, 稱之為 UDID
            - 甚至連 simulator 也有 UDID
        - Entitlements & Sandbox
            - App Sandbox 的 infrastructure 與 code signing infrastructure 不同
        - Certificate
        - 可用設備的 Device IDs
    - 使用 Apple ID 登入 xcode 以後, 會自動在 host 產生此檔案(無需額外設定)
    - 定義了可以在 App 的 running rules
        - 可以視為一種保護機制, 避免 App 執行了 rules 以外的代碼(可能被篡改了)
    - 依照用途可分為:
        - Development
            - 限制哪些 Device 可以安裝此 Development App
            - 一個 App 上限為 100 個 Device IDs
        - Distribution
            - 無裝置限制


# build & publish iOS App

- build iOS App 會陸續做各種動作, 像是 linting, compiling, linking, ... (總之我不確定)
    - 最後會做 Archive 這個動作, 此時需要有相對應的 Provisioning Profile, 驗證通過後, 才能做 包版(Archiving) 這個動作
    - 完成後會出現關鍵字: `Archive Succeeded`
- build iOS App 完成後, 把 ipa 上傳到 **App Store Connect** 審核
    - 前身名為 iTunes Connect (但似乎是 Apple 那邊服務調整, 因而把 App 這塊獨立出來)
    - 而上傳到當事人(CI/CD Pipeline) 的 Role, 需要 "App Manager" 或 "Admin"
        - "Developer" role 也能夠將 builds 做上傳, 不過不能上傳 build information and testers
        - 此段說明出自 https://docs.fastlane.tools/actions/pilot/
        - 關於 Program Roles 可參考 https://developer.apple.com/support/roles/
- 任何一款 iOS App 都需要一組 globally unique 的 **bundle identifier**
    - ex: "com.tonychoucc.dev" / "com.tonychoucc.debug" / "com.tonychoucc"
    - 需要在 Xcode 裡頭設定這個東西. 
        - 如果使用 fastlane 的話, 可以參考 `update_app_identifier` (我還沒用過)
- build iOS App 的時候, 可以選擇多種 [Distribution methods](https://help.apple.com/xcode/mac/current/#/dev31de635e5)


# Reference

- [Provisioning profile](https://shubo.io/provisioning-profile/#:~:text=Provisioning%20profile%20%E6%98%AF%E4%B8%80%E7%B5%84,%E6%8C%87%E5%AE%9A%E7%9A%84%E8%A3%9D%E7%BD%AE%E4%B8%8A%E9%81%8B%E8%A1%8C%E3%80%82)
- [iOS App 上架流程](https://franksios.medium.com/ios-app%E4%B8%8A%E6%9E%B6%E6%B5%81%E7%A8%8B%E5%9C%96%E6%96%87%E6%95%99%E5%AD%B8-724636ddc78b)
- [fastlane - Best Practices and Tips](https://www.joshholtz.com/altconf-fastlane-best-practices/#slide=1)
- [How to export an Ad Hoc iOS ipa using Xcode](https://www.andrewhoog.com/post/how-to-export-ad-hoc-ios-ipa-xcode/)
