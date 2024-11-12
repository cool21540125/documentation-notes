#!/bin/bash
exit 0
# ==================================================================================================================================================================

AWS_ACCOUNT_ID=

### List quicksight users
# https://docs.aws.amazon.com/quicksight/latest/developerguide/list-users.html
aws quicksight list-users --aws-account-id $AWS_ACCOUNT_ID --namespace default

### Delete quicksight user (每個 Author 都在燒錢)
# https://docs.aws.amazon.com/quicksight/latest/developerguide/delete-user.html
aws quicksight delete-user \
  --user-name tony \
  --aws-account-id $AWS_ACCOUNT_ID \
  --namespace default

###
