
# java 及 javac 的環境變數

- JAVA_HOME
- `javac -sourcepath SRC.java`, 尋找 java src code 的路徑
    - 覆寫 `SOURCEPATH`
- `java -classpath $CLASS`, 尋找 class 及 jar 的路徑
    - 覆寫 `CLASSPATH`
    - `-classpath` 可簡化成 `-cp`
- `javac -d DIR`, 用來放置 class 的產出路徑

