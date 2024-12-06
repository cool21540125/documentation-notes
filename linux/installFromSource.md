# Install binary / commmand / packages from Source Code

# Install Terraform

- 2022/12/30
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)

```zsh
### 法1. (放棄使用 brew 吧!!) (需要依賴噁爛到爆的 xcode) -----------------
# install the HashiCorp tap, a repository of all our Homebrew packages.
# brew tap hashicorp/tap
# brew install hashicorp/tap/terraform


### 法2. 尊重生命, 選離 xcode -- 直接抓 binary -----------------
terraform version
#Terraform v1.3.6
#on darwin_amd64


### 法3. from source (golang required!!) -----------------
git clone https://github.com/hashicorp/terraform.git
cd terraform

git checkout xxx


# 會 build 出像是 "1.5.0-dev" 的版本, 若想 build 出正式版本, 可參考 BUILDING.md#Dev Version Reporting
go build


# build released version
go build -ldflags "-w -s -X 'github.com/hashicorp/terraform/version.dev=no'" -o ~/bin/

mv dist/terraform ~/bin/

### Terraform tab completion
terraform -install-autocomplete
```

# Install go

- [go - All releases](https://go.dev/dl/)

```bash
cd ~/Download
GOVERSION=1.23.3
wget "https://go.dev/dl/go${GOVERSION}.linux-amd64.tar.gz"  # 自行變更版本

tar -xvf "go${GOVERSION}.linux-amd64.tar.gz"
rm -f "go${GOVERSION}.linux-amd64.tar.gz"
sudo mv go /usr/local/

echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export PATH="$GOROOT/bin:$PATH"' >> ~/.bashrc
```
