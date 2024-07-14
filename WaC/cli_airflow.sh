#!/bin/bash
exit 0
# ---------------------

###################################################################################################
# Basic Usage
###################################################################################################

### 懶人包 local test - getting started
airflow standalone


### init DB
airflow users create \
    --username admin \
    --firstname Peter \
    --lastname Parker \
    --role Admin \
    --email spiderman@superhero.org


### 升級時使用
airflow db migrate


### (必備) run server
airflow webserver --port 8080

### (必備) run scheduler
airflow scheduler


###################################################################################################
# 
###################################################################################################
