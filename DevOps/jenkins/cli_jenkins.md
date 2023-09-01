

- [jenkins plugin manager](https://github.com/jenkinsci/plugin-installation-manager-tool)
    - jenkins 的套件管理員, 有他自己的一套 CLI
    - [jenkins-plugin-manager](https://github.com/jenkinsci/plugin-installation-manager-tool/releases)


```bash
### Jenkins install jenkins-plugin-cli
$# java -jar jenkins-plugin-manager-*.jar \
    --war /your/path/to/jenkins.war \
    --plugin-file /your/path/to/plugins.txt \
    --plugins delivery-pipeline-plugin:1.3.2 \
    deployit-plugin


### 
$# 
jenkins-plugin-manager



### install jenkins plugin
$# jenkins-plugin-cli --plugins ${PluginName}:${PluginVersion}
```