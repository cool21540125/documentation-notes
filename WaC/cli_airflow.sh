#!/bin/bash
exit 0
# ---------------------

### ========================================= Start airflow =========================================

airflow standalone
airflow webserver --port 8080
# 上面為 test 環境, 下面較適合 production
airflow
### (必備) run server

### ========================================= Admin =========================================

### init DB
airflow users create \
    --username admin \
    --firstname Peter \
    --lastname Parker \
    --role Admin \
    --email spiderman@superhero.org

### 升級時使用
airflow db migrate

### (必備) run scheduler
airflow scheduler

### ========================================= 一般使用 =========================================
# airflow tasks test 要測試的_DAG_ID TASK_ID EXECUTION_TIME

### 運行測試 DAG
airflow tasks test example_bash_operator runme_0 2015-01-01

# airflow dags backfill 要重跑過去歷史資料的_DAG_ID TASK_ID
### a
airflow dags backfill example_bash_operator \
    --start-date 2015-01-01 \
    --end-date 2015-01-02
