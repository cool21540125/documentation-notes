# SSH Agent

- [SSH Agent Forwarding considered harmful](https://heipei.github.io/2015/02/26/SSH-Agent-Forwarding-considered-harmful/)
- [SSH agent forwarding 教學](https://blog.wu-boy.com/2016/10/ssh-agent-forwarding-proxycommand-tutorial/)

WARNING: Since 2016/11, SSH Agent Forwarding 已經被視為不安全. 應改用 `ProxyCommand` 取代

`ssh-add` 指令本身是用來將 "事前建立好的 private key" 加入到 SSH authentication agent 來實作「藉由 ssh 達成 SSO」, 這個 agent process 稱之為 `ssh-agent`

# Reference

- [SSH Keys for SSO: Usage, ssh-add Command, ssh-agent](https://www.ssh.com/academy/ssh/add-command)

```conf
### 配置範例 : jms -> ec2
Host jms
    HostName     11.11.11.11
    User         USER
    IdentityFile ~/.ssh/JumpServerSSHKey.pem
Host ec2
    Hostname     22.22.22.22
    User         USER
    Port         22
    ProxyCommand ssh -q -W %h:%p jms
    IdentityFile ~/.ssh/id_rsa
```
