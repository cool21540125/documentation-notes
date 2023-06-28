
# plist

```xml
<!-- /Library/LaunchDaemons/homebrew.mxcl.jenkins-lts.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>homebrew.mxcl.jenkins-lts</string>
  <key>LimitLoadToSessionType</key>
  <array>
    <string>Aqua</string>
    <string>Background</string>
    <string>LoginWindow</string>
    <string>StandardIO</string>
    <string>System</string>
  </array>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/opt/openjdk@17/bin/java</string>
    <string>-Dmail.smtp.starttls.enable=true</string>
    <string>-DJENKINS_HOME=/Users/cool21540125/.jenkins</string>
    <string>-jar</string>
    <string>/usr/local/opt/jenkins-lts/libexec/jenkins.war</string>
    <string>--httpListenAddress=0.0.0.0</string>
    <string>--httpPort=8080</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key><string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>UserName</key><string>cool21540125</string>
</dict>
</plist>
```
