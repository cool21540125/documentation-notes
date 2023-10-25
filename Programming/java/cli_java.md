
# java 及 javac 的環境變數

- JAVA_HOME
- `javac -sourcepath SRC.java`, 尋找 java src code 的路徑
    - 覆寫 `SOURCEPATH`
- `java -classpath $CLASS`, 尋找 class 及 jar 的路徑
    - 覆寫 `CLASSPATH`
    - `-classpath` 可簡化成 `-cp`
- `javac -d DIR`, 用來放置 class 的產出路徑

```bash
# 配置 JAVA_HOME 用這個吧
export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"
```


# CLI jar

```bash
### 列出 jar 內容
jar tf xxx.jar
#META-INF/
#META-INF/MANIFEST.MF
#com/
#com/example/
#com/example/xxx.class


### 
```
