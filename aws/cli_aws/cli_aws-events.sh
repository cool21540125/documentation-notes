#!/bin/bash
exit 0
# --------------------------------------------------------------------------------

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/events/put-events.html
aws events put-events --entries file://putevents.json
