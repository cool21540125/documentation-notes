


```bash
### 給 Telegram 頻道的 Token
$# bot_token="1770026560:AAHLIzvzlD8wNMZoNewNlxRq5ijCcZeu_eM"
$# curl -s "https://api.telegram.org/bot${bot_token}/getUpdates" | python -mjson.tool
{
    "ok": true,
    "result": [
        {
            "message": {
                "chat": {
                    "first_name": "Chou",
                    "id": 1065399501,  ## <-- ChatID
                    "last_name": "Tony",
                    "type": "private"
                },
                "date": 1627452568,
                "entities": [
                    {
                        "length": 6,
                        "offset": 0,
                        "type": "bot_command"
                    }
                ],
                "from": {
                    "first_name": "Chou",
                    "id": 1065399501,
                    "is_bot": false,
                    "language_code": "zh-hans",
                    "last_name": "Tony"
                },
                "message_id": 61,
                "text": "/start"
            },
            "update_id": 299049859
        }
    ]
}
```