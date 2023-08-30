
- Provisioning profile
    - 一組設定檔, 主要用途:
        - 確保正確的簽署 App
            - iOS App 要上架到 **App Store** 都需要 sign
                - private key 簽署
                - public key / Certificate 驗證 App 開發者身份
        - 確保 App 能夠安全地在指定的裝置上運行
    - 包含了底下的資訊:
        - Certificate
        - App ID
        - 可用設備的 Device IDs
    - 依照用途可分為:
        - Development  - 限制 100 個 Device IDs
        - Distribution - 無裝置限制



# Reference 101

- [Provisioning profile](https://shubo.io/provisioning-profile/#:~:text=Provisioning%20profile%20%E6%98%AF%E4%B8%80%E7%B5%84,%E6%8C%87%E5%AE%9A%E7%9A%84%E8%A3%9D%E7%BD%AE%E4%B8%8A%E9%81%8B%E8%A1%8C%E3%80%82)
- [iOS App 上架流程](https://franksios.medium.com/ios-app%E4%B8%8A%E6%9E%B6%E6%B5%81%E7%A8%8B%E5%9C%96%E6%96%87%E6%95%99%E5%AD%B8-724636ddc78b)
- [fastlane - Best Practices and Tips](https://www.joshholtz.com/altconf-fastlane-best-practices/#slide=1)