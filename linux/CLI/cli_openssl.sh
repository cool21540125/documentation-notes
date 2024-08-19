#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------

### 取得 Server Certificate
DOMAIN=blog.tonychoucc.com
# with SNI
openssl s_client -showcerts -servername $DOMAIN -connect $DOMAIN:443

# without SNI
openssl s_client -showcerts -connect $DOMAIN:443
