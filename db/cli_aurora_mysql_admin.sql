

-- binlog
CALL mysql.rds_set_configuration('binlog retention hours', 2);
CALL mysql.rds_show_configuration;