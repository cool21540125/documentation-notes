# Install neo4j

```bash
### ===================== Docker Containerize =====================
docker pull neo4j:5.24-community

### ===================== Local Dev Test for macbook =====================
# https://neo4j.com/docs/operations-manual/current/installation/osx/
#
# Step1. 下載安裝 JDK17
# Step2. 下載安裝 Neo4j (解壓縮以後, 會是一包編譯完成後的 Dir, 內含 bin, lib, ...)
# Step3. 配置環境變數 & 同意服務條款
export NEO4J_HOME=${PATH_TO_STEP2_DIR_LOCATION}
export NEO4J_ACCEPT_LICENSE_AGREEMENT=yes
$NEO4J_HOME/bin/neo4j-admin server license --accept-commercial

# Step4. 前景啟動
$NEO4J_HOME/bin/neo4j console

# 執行 neo4j-shell
$NEO4J_HOME/bin/cypher-shell
```

# Doc

https://neo4j.com/docs/
