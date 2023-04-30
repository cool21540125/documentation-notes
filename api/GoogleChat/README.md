
# Google Chat API

## spaces.messages - Method: spaces.messages.create

- https://developers.google.com/chat/api/reference/rest/v1/spaces.messages/create

- query string: `messageReplyOption`
    - MESSAGE_REPLY_OPTION_UNSPECIFIED     : 直接發送到 new thread
    - REPLY_MESSAGE_FALLBACK_TO_NEW_THREAD : 回應給 thread (若失敗, 發送到 new thread)
    - REPLY_MESSAGE_OR_FAIL                : 回應給 thread (若失敗, 回傳 NOT_FOUND error)


- [Card Builder](https://gw-card-builder.web.app/#)
