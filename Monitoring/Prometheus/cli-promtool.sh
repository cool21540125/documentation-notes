#!/bin/bash
exit 0
# --------------------------------------------------------------

### 驗證 prometheus config file
promtool check config config/prometheus.yml


### 驗證 prometheus rule file
promtool check rules /PATH/TO/rule.yml


### test rules
promtool test rules /PATH/TO/rule.yml
promtool test rules /PATH/TO/test_rule1.yml /PATH/TO/test_rule2.yml /PATH/TO/test_rule3.yml


### 