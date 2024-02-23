
- [很難讀懂的官方](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/10000172i-SW7-BCIEDDBJ
- [Launchctl difference between load and start, unload and stop](https://apple.stackexchange.com/questions/29056/)launchctl-difference-between-load-and-start-unload-and-stop)

![launchd](./img/launchd.png)

```zsh
### 使用 Launch Daemon
svc=
plist=/Library/LaunchDaemons/$svc.plist

sudo launchctl unload -w $plist
sudo launchctl load -w $plist

sudo launchctl list | grep $svc
```
