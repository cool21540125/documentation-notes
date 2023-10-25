# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
# 
# 
# ------------------------------------------------------------------------------

### List instances
aws ec2 describe-instances

# filter - instanceId
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId" | yq '.[]'

# filter - EIP & DnsName
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].NetworkInterfaces[].Association"



### Start instance (which is stopped)
aws ec2 start-instances --instance-ids $InstanceId
#StartingInstances:
#- CurrentState:
#    Code: 0
#    Name: pending
#  InstanceId: i-xxxxxxxxxxxxxxxxx
#  PreviousState:
#    Code: 80
#    Name: stopped


### ====================================================== 
### start EC2
AWS_REGION=ap-northeast-1         # IMAGE 會綁定 Region, 可用這個來做切換
IMAGE_ID=ami-0b7546e839d7ace12    # ap-northeast-1 的 Amazon Linux 2 AMI x86-64
aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type t2.micro \
    --key-name ${KEY} \
    --dry-run

An error occurred (DryRunOperation) when calling the RunInstances operation: Request would have succeeded, but DryRun flag is set.
# 如果看到這樣, 表示指令可成功下達. 但因家了 --dry-run, 所以沒實際跑下去


### ====================================================== 


### 啟動 EC2 的 detailed monitoring
aws ec2 monitor-instances --instance-ids ${Instance_ID}


### 