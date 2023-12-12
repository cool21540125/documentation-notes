


API_URL=$(aws cloudformation describe-stacks --stack-name workshop-aws-lambda --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldApi`].OutputValue' --output text)
LAMBDA_ARN=$(aws cloudformation describe-stacks --stack-name workshop-aws-lambda --query 'Stacks[0].Outputs[?OutputKey==`HelloWorldFunction`].OutputValue' --output text)
echo API_URL=$API_URL
echo LAMBDA_ARN=$LAMBDA_ARN


### invoke lambda with event
aws lambda invoke --function-name $LAMBDA_ARN --payload '{}' --output json result.json


### 