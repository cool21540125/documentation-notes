#!/bin/bash
exit 0
#
# 同 LM Studio (lms) 用來跑 local models
#
#
# --------------------------------------------------------

ollama --version
#ollama version is 0.23.2


ollama ls
#NAME             ID              SIZE      MODIFIED
#gemma4:latest    c6eb396dbd59    9.6 GB    18 minutes ago



ollama run gemma4

ollama ps

ollama stop gemma4

ollama pull ${MODEL_NAME}
ollama rm ${MODEL_NAME}

