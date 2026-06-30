#!/bin/bash
exit 0
# --------------------------

## Run MCP Server
fastmcp run xxx.py                               # 運行 MCP Server 接收 stdio
fastmcp run xxx.py --transport http --port 8000  # 運行 MCP Server 接收 Streamable HTTP
# 如果使用 uv 的話....
uv run fastmcp run xxx.py
uv run fastmcp run xxx.py --transport http --port 8000


## 
uv run fastmcp dev apps xxx.py --port 8000


## ====================== config.json ======================
fastmcp run xxx.py -- --config config.json


## ====================== fastmcp Parameters ======================
# 
# `--config config.json`
# `--debug`
# `--transport http`
# `--port 28001`
# `--reload`
