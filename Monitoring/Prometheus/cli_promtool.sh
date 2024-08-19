#!/bin/bash
exit 0
# --------------------------------------------------------------

### check whether a rule file is syntactically correct
promtool check rules /path/to/example.rules.yml

# Usage
promtool check rules /var/www/docker/prometheus/config/rule*.yml

### 驗證 prometheus config file
promtool check config config/prometheus.yml

# Usage
promtool check config /var/www/docker/prometheus/config/prometheus/prometheus.yml
amtool check-config /var/www/docker/prometheus/config/alertmanager/alertmanager.yml

### 驗證 prometheus rule file
promtool check rules /etc/prometheus/rules.yml
# container
docker exec prometheus promtool check rules /etc/prometheus/rules.yml

### unit test rules
promtool test rules /PATH/TO/rule.yml
promtool test rules /PATH/TO/test_rule1.yml /PATH/TO/test_rule2.yml /PATH/TO/test_rule3.yml

###

curl -X POST http://localhost:29090/-/reload -u admin
curl -X POST http://localhost:29093/-/reload
