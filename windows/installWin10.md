
Win10 安裝一堆有的沒的

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


wsl 相對於 win10 的路徑: `\\wsl$\Ubuntu\home\tony`


# Install choco

- 2022/04/19
- [INSTALLING CHOCOLATEY](https://chocolatey.org/install)

### 法1

必須使用系統管理權限

```powershell
### install
> Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

### 升級 choco
> choco upgrade Chocolatey

### 列出本地 choco 安裝了哪些 && 其相關資訊
> choco list -li

### 列出遠端 choco 可用套件
> choco list
# ↑ 這個會列出遠端所有可安裝的套件...

### choco 版本
> choco --version
1.1.0
```

### 法2

直接安裝 `node.js`, 裏頭其中一步驟可勾選安裝 choco


# Install gcc

- [exec: "gcc": executable file not found in %PATH% when trying go build](https://stackoverflow.com/questions/43580131/exec-gcc-executable-file-not-found-in-path-when-trying-go-build)

1. 先安裝好 `choco`
2. `choco install mingw -y`
    - 系統管理員執行
3. 把上述安裝好的路徑, 加入到 **環境變數**

```powershell
> gcc --version
gcc.exe (MinGW-W64 x86_64-posix-seh, built by Brecht Sanders) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```


# Install hugo

```powershell
# (系統管理員執行) 先安裝好 choco
> choco install hugo

> hugo version
```