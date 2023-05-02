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


### 
