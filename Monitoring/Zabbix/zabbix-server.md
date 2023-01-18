# server


```sh
### Zabbix Server 指令
$# zabbix_server --help
usage:
  zabbix_server [-c config-file]
  zabbix_server [-c config-file] -R runtime-option
  zabbix_server -h
  zabbix_server -V

The core daemon of Zabbix software.

Options:
  -c --config config-file        Path to the configuration file
                                 (default: "/etc/zabbix/zabbix_server.conf")
  -f --foreground                Run Zabbix server in foreground
  -R --runtime-control runtime-option   Perform administrative functions

    Runtime control options:
      config_cache_reload        Reload configuration cache
      housekeeper_execute        Execute the housekeeper
      log_level_increase=target  Increase log level, affects all processes if
                                 target is not specified
      log_level_decrease=target  Decrease log level, affects all processes if
                                 target is not specified

      Log level control targets:
        process-type             All processes of specified type
                                 (alerter, alert manager, configuration syncer,
                                 discoverer, escalator, history syncer,
                                 housekeeper, http poller, icmp pinger,
                                 ipmi manager, ipmi poller, java poller,
                                 poller, preprocessing manager,
                                 preprocessing worker, proxy poller,
                                 self-monitoring, snmp trapper, task manager,
                                 timer, trapper, unreachable poller,
                                 vmware collector)
        process-type,N           Process type and number (e.g., poller,3)
        pid                      Process identifier, up to 65535. For larger
                                 values specify target as "process-type,N"

  -h --help                      Display this help message
  -V --version                   Display version number

Some configuration parameter default locations:
  AlertScriptsPath               "/usr/share/zabbix/alertscripts"
  ExternalScripts                "/usr/share/zabbix/externalscripts"
  SSLCertLocation                "/usr/share/zabbix/ssl/certs"
  SSLKeyLocation                 "/usr/share/zabbix/ssl/keys"
  LoadModulePath                 "/usr/lib64/zabbix/modules"

Report bugs to: <https://support.zabbix.com>
Zabbix home page: <http://www.zabbix.com>
Documentation: <https://www.zabbix.com/documentation>

###
$# zabbix_server -R config_cache_reload
```
