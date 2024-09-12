#!/usr/bin/env bash
exit 0
# ------------------------------------

AWS_ACCOUNT=$(aws sts get-caller-identity --output json | jq -r ".Account")
AWS_USERNAME=$(aws iam get-user --output json | jq -r ".User.UserName")
AWS_REGION=ap-northeast-1

# How do I assume an IAM role using the AWS CLI
#   https://www.youtube.com/watch?v=-uogKFE1r60&ab_channel=AmazonWebServices

# CLI - assume an IAM role using AWS CLI

### 建立 iam.Policy
aws iam create-policy \
    --policy-name better-developer-experience \
    --description "Created via Aws Cli. For better develop experience." \
    --policy-document file://_BetterDeveloperExperiencePolicy.json \
    --tags "Key=CreatedVia,Value=cli" "Key=Usage,Value=Better for Iam User to use AWS"
#
aws iam create-policy \
    --policy-name better-sre-experience \
    --description "Created via Aws Cli. For SRE required permissions." \
    --policy-document file://_SreRequiredPolicy.json \
    --tags "Key=CreatedVia,Value=cli" "Key=Usage,Value=Enlarge SRE permissions"
#

### 建立 IAM User
aws iam create-user --user-name test-user

### IAM Policy definition
cat <<EOF >test-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "iam:ListRoles",
                "sts:AssumeRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF
# ------------------------------------

### 依照本地 trust policy json file 建立 Role
aws iam create-role --role-name demo-role --assume-role-policy-document file://demo-trust-policy.json
# 建立一個 Role, 名為 demo-role
# Permissions policies 會在下一步 attach

aws iam put-role-policy --role-name demo-role --policy-name Perms-Policy-For-CognitoFederation --policy-document file://permspolicyforcognitofederation.json

### 依照本地檔案, 建立 Policy
aws iam create-policy --policy-name test-polich --policy-document file://test-policy.json

### 將 policy attach 給 user
aws iam attach-user-policy \
    --user-name test-user \
    --policy-arn arn:aws:iam::${AWS_ACCOUNT}:policy/test-polich

### 查看 User 已有的 Policies
aws iam list-attached-user-policies \
    --user-name test-user

### 為 User 建立 Access Key
aws iam create-access-key \
    --user-name test-user
# 可從 CLI Response 看到 AccessKeyId && SecretAccessKey

###
cat <<EOF >test-role-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::${AWS_ACCOUNT}:root" },
        "Action": "sts:AssumeRole"
    }
}
EOF
# 解釋
# 此 Policy 的 主體(Principal) 是針對 root User
# 用來允許所有 此帳戶內的 IAM user,
# 如果他們對於 sts:AssumeRole API 有足夠的 IAM Permission, 則可用來 assume this role

### 建立前述的 Role
ROLE_NAME_ON_AWS="test-powerful-role"
aws iam create-role \
    --role-name ${ROLE_NAME_ON_AWS} \
    --assume-role-policy-document file://test-role-trust-policy.json
# 把 Arn 記錄下來...

###
Arn="arn:aws:iam::${AWS_ACCOUNT}:role/${ROLE_NAME_ON_AWS}"
aws iam attach-role-policy \
    --role-name ${ROLE_NAME_ON_AWS} \
    --policy-arn ${Arn}
# 忘了怎麼解釋...

### 賦予 AWS 內建的 `RDS ro 權限` 給 Role
RDS_ro_Arn="arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
aws iam attach-role-policy \
    --role-name ${ROLE_NAME_ON_AWS} \
    --policy-arn ${RDS_ro_Arn}
# 此為 Permission policy

### 用來查看 Role 具備了哪些 Policies
aws iam list-attached-role-policies \
    --role-name ${ROLE_NAME_ON_AWS}

###
aws sts assume-role \
    --role-arn "" \
    --role-session-name AWSCLI-Session

###
aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" || aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"
aws iam get-role --role-name "AWSServiceRoleForECS" || aws iam create-service-linked-role --aws-service-name "ecs.amazonaws.com"
# https://catalog.us-east-1.prod.workshops.aws/workshops/869f7eee-d3a2-490b-bf9a-ac90a8fb2d36/en-US/3-setup/02-setup-environments
# 還不太會解讀上面這個 linked-role....

### 列出 Group 內的 `inline policies` 及 `attached policies`
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/list-group-policies.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/list-attached-group-policies.html
IAM_GROUP=DevOps
aws iam list-group-policies --group-name $IAM_GROUP
aws iam list-attached-group-policies --group-name $IAM_GROUP
