#Gets credential for AWS ECR
echo "Environment: ${ENV}"
echo "AWS Account: ${AWS_ACCOUNT}"
echo "AWS Region: ${AWS_REGION}"

aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT}".dkr.ecr."${AWS_REGION}".amazonaws.com

cd ..

gradle build

docker build -t config-"${ENV}" .

docker tag config-"${ENV}":latest "${AWS_ACCOUNT}".dkr.ecr."${AWS_REGION}".amazonaws.com/config-repository-"${ENV}":latest

docker push "${AWS_ACCOUNT}".dkr.ecr."${AWS_REGION}".amazonaws.com/config-repository-"${ENV}":latest


