#!/bin/bash
exit 0

ssh -i /PATH/TO/KEY.pem USER@REMOTE_IP -N -L 9200:$WEB_URL:443
