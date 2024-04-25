# Turning off the AWS pager so that the CLI doesn't open an editor for each command result
export AWS_PAGER=""
echo "Deploying in Environment ${ENV}"

aws cloudformation create-stack \
--stack-name network-stack \
--template-body file://01-network.yml \
--parameters ParameterKey=Environment,ParameterValue="${ENV}" \
--capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete \
  --stack-name network-stack


aws cloudformation create-stack \
--stack-name ecs-cluster \
--template-body file://02-ecs-cluster.yml \
--parameters ParameterKey=Environment,ParameterValue="${ENV}" \
--capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete \
  --stack-name ecs-cluster

sh sh-004-build-config.sh
echo "${AWS_ACCOUNT}".dkr.ecr."${AWS_REGION}".amazonaws.com/config-repository-"${ENV}":latest


aws cloudformation create-stack \
--stack-name config-ecs-task-definition \
--template-body file://03-ecs-config-task-definition.yml \
--parameters ParameterKey=Environment,ParameterValue="${ENV}" ParameterKey=ImageUrl,ParameterValue="${AWS_ACCOUNT}".dkr.ecr."${AWS_REGION}".amazonaws.com/config-repository-"${ENV}":latest

aws cloudformation wait stack-create-complete \
  --stack-name config-ecs-task-definition


aws cloudformation create-stack \
--stack-name config-svc-deploy \
--template-body file://04-ecs-service-config.yml

aws cloudformation wait stack-create-complete \
  --stack-name config-svc-deploy
