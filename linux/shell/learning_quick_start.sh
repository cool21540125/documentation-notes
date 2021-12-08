#!/bin/bash
# 此為 jumpserver 的快速安裝腳本
#     https://github.com/jumpserver/jumpserver/releases/download/v2.9.2/quick_start.sh

function prepare_check() {
  isRoot=$(id -u -n | grep root | wc -l)  ##
  if [ "x$isRoot" != "x1" ]; then
    echo -e "[\033[31m ERROR \033[0m] Please use root to execute the installation script (请用 root 用户执行安装脚本)"
  fi
  processor=$(cat /proc/cpuinfo | grep "processor" | wc -l)  ##
  if [ $processor -lt 2 ]; then
    echo -e "[\033[31m ERROR \033[0m] The CPU is less than 2 cores (CPU 小于 2核，JumpServer 所在机器的 CPU 需要至少 2核)"
    exit 1
  fi
  memTotal=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')  ##
  if [ $memTotal -lt 3750000 ]; then
    echo -e "[\033[31m ERROR \033[0m] Memory less than 4G (内存小于 4G，JumpServer 所在机器的内存需要至少 4G)"
    exit 1
  fi
}

function install_soft() {
  if command -v dnf >/dev/null; then  ##
    if [ "$1" == "python" ]; then
      dnf -q -y install python2
      ln -s /usr/bin/python2 /usr/bin/python
    else
      dnf -q -y install $1
    fi
  elif command -v yum >/dev/null; then
    yum -q -y install $1
  elif command -v apt >/dev/null; then
    apt-get -qqy install $1
  elif command -v zypper >/dev/null; then
    zypper -q -n install $1
  elif command -v apk >/dev/null; then
    apk add -q $1
  else
    echo -e "[\033[31m ERROR \033[0m] Please install it first (请先安装) $1 "
    exit 1
  fi
}

function prepare_install() {
  for i in curl wget zip python; do
    command -v $i &>/dev/null || install_soft $i  ## 判斷指令是否可用. 若有誤(不存在, 則離開並告知安裝)
  done
}

function get_installer() {
  echo "download install script to /opt/jumpserver-installe (开始下载安装脚本到 /opt/jumpserver-installe)"
  Version=$(curl -s 'https://api.github.com/repos/jumpserver/installer/releases/latest' | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')  ## 取出版本號, 最後的那個 sed, 只是作了多次取代
  if [ ! "$Version" ]; then
    echo -e "[\033[31m ERROR \033[0m] Network Failed (请检查网络是否正常或尝试重新执行脚本)"
  fi
  cd /opt
  if [ ! -d "/opt/jumpserver-installer-$Version" ]; then
    wget -qO jumpserver-installer-$Version.tar.gz https://github.com/jumpserver/installer/releases/download/$Version/jumpserver-installer-$Version.tar.gz || {  ##
      rm -rf /opt/jumpserver-installer-$Version.tar.gz
      echo -e "[\033[31m ERROR \033[0m] Failed to download jumpserver-installer (下载 jumpserver-installer 失败, 请检查网络是否正常或尝试重新执行脚本)"
      exit 1
    }
    tar -xf /opt/jumpserver-installer-$Version.tar.gz -C /opt || {
      rm -rf /opt/jumpserver-installer-$Version
      echo -e "[\033[31m ERROR \033[0m] Failed to unzip jumpserver-installe (解压 jumpserver-installer 失败, 请检查网络是否正常或尝试重新执行脚本)"
      exit 1
    }
    rm -rf /opt/jumpserver-installer-$Version.tar.gz
  fi
}

function config_installer() {
  cd /opt/jumpserver-installer-$Version
  JMS_Version=$(curl -s 'https://api.github.com/repos/jumpserver/jumpserver/releases/latest' | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
  if [ ! "$JMS_Version" ]; then
    echo -e "[\033[31m ERROR \033[0m] Network Failed (请检查网络是否正常或尝试重新执行脚本)"
    exit 1
  fi
  sed -i "s/VERSION=.*/VERSION=$JMS_Version/g" /opt/jumpserver-installer-$Version/static.env
  ./jmsctl.sh install
}

function main() {
  prepare_check
  prepare_install
  get_installer
  config_installer
}

main
