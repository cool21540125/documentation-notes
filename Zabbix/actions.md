
Zabbix Server Web 上面支援的所有 macros 的清單解說

- [Supported macros 4.0](https://www.zabbix.com/documentation/4.0/manual/appendix/macros/supported_by_location)
- [Supported macros 5.0](https://www.zabbix.com/documentation/5.0/manual/appendix/macros/supported_by_location)


- {EVENT.NAME}
    - 使用情境
        - Trigger-based notifications and commands
        - Problem update notifications and commands
    - 說明
        - Name of the problem event that triggered an action. Supported since 4.0.0. ​
- {TRIGGER.NAME}
    - 使用情境
        - Trigger-based notifications and commands
        - Problem update notifications and commands
        - Trigger-based internal notifications
    - 說明
        - Name of the trigger (with macros resolved). Note that since 4.0.0 {EVENT.NAME} can be used in actions to display the triggered event/problem name with macros resolved.