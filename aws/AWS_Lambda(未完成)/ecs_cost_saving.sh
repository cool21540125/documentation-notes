#!/bin/bash

function start() {
  FUNC=$1
  echo "You are running $FUNC"

  aws configure set cli_pager ""

  aws ecs list-clusters --output text | awk '{print $2}' | while IFS= read -r ECS_CLUSTER; do
    # aws ecs list-services --cluster $ECS_CLUSTER --output text | awk '{print $2}' | while IFS= read -r ECS_SERVICE; do
    #   aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE
    #   echo "----"
    # done
    echo "**************************************************************"
  done

}
