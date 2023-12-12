
# Build System

- Bazel
    - Google 內部使用的是 Blaze, 而 Bazel 則是開園後的版本
        - 有點像是 Google 內部使用 Borg, 而開源的部分稱之為 Kubernetes
    - Open-Source by Google in 2015
    - Language: 跨語言
    - Cross Platform
    - Learning Curve
        - 適用於超大型系統, 能控制非常多細節, 學習曲線陡峭
    - 有哪些知名公司使用
        - Google
        - Stripe
        - Netflix
- Buck
    - Open-Source by Facebook
        - Buck was a Bazel clone built at Facebook
    - Language: 跨語言
    - Cross Platform
    - Learning Curve
- Pants
    - Open-Source by Twitter
        - Pants was a Bazel clone used at Twitter and Foursquare
    - Language
        - v1 僅支援 Python (in 2022)
        - v2 的話不曉得...
    - Learning Curve
- Rush
    - Open-Source by Microsoft
    - Language: 僅支援 JavaScript
    - Learning Curve
- Lage
    - by Microsoft
- Lerna
    - JS / TS 的 build system 管理工具
- moon
    - by moonrepo
- Nx
    - bu NRWL
    - Cross Platform
    - Language
        - 最早是為了 for Angular, 後來逐漸擴充到 React / Vite / JS backend framework
        - 後來逐漸支援其他語言, ex: nx-dotnet
    - Learning Curve
        - JS Developers 容易上手
- Earthly
    - Open-Source
    - Language
        - 跨語言
    - 早期 for Linux Only. 但現在也支援 MacOS 及 Windows WSL 2
    - Learning Curve
        - 類似於 Dockerfile 的撰寫
- Gradle
    - by Gradle Inc
- Turborepo
    - by Vercel


# References

- [monorepo.tools](https://monorepo.tools/#understanding-monorepos)
- [Monorepo Build Tools](https://earthly.dev/blog/monorepo-tools/)
