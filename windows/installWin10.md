

# Install MINGW64

- [MINGW64 "make build" error: "bash: make: command not found"](https://stackoverflow.com/questions/36770716/mingw64-make-build-error-bash-make-command-not-found)

1. 前往 https://sourceforge.net/projects/ezwinports/files/
2. 下載 `make-x.y.z-without-guile-w32-bin.zip` (without guild 那個)
3. 解壓縮
4. 複製到 git 路徑底下, 貼上 (不要取代任何東西)

讓 Win 10 可使用 `make` CLI


# Install wsl2

1. 系統管理員方式執行 Powershell
2. `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
3. `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
4. 下載安裝 [WSL2 Linux 核心更新套件 (適用於 x64 電腦)](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi) ← 如果連結掛了, 再到 [較舊版本的 WSL 手動安裝步驟](https://docs.microsoft.com/zh-tw/windows/wsl/install-manual) 找尋對應的下載點來安裝 **WSL2 Linux 核心更新套件**
5. `wsl --update`  -> 5.10.60.1 (2021/12/07)
6. `Win + R` -> `store` -> 尋找 `Ubuntu` -> `取得` -> 等他一陣子下載 & 安裝
7. 