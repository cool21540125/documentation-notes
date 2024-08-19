#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/publish.html
# ----------------------------

aws sns publish \
  --topic-arn $TOPIC \
  --subject Title --message test \
  --debug
