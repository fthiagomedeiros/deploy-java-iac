# Turning off the AWS pager so that the CLI doesn't open an editor for each command result
export AWS_PAGER=""

#!/bin/bash


echo "Before call this script you must manually delete the uploaded docker image in ECR\n"

# Function to confirm action
confirm_action() {
    read -p "$1 (yes/no): " choice
    case "$choice" in 
        yes|YES|Yes|y|Y ) return 0 ;;
        no|NO|No|n|N ) return 1 ;;
        * ) echo "Please respond with 'yes' or 'no'." ;;
    esac
}

# Prompt user for confirmation
confirm_action "Do you want to delete AWS CloudFormation stacks?"

# If user confirms, execute delete stack commands
if [ $? -eq 0 ]; then
    echo  "Please wait while the template are being deleted."

    echo  "Deleting  config-svc-deploy"
    aws cloudformation delete-stack --stack-name config-svc-deploy
    aws cloudformation wait stack-delete-complete --stack-name config-svc-deploy
    echo  "deleted  config-svc-deploy stack"
    
    echo  "Deleting config-ecs-task-definition"
    aws cloudformation delete-stack --stack-name config-ecs-task-definition
    aws cloudformation wait stack-delete-complete --stack-name config-ecs-task-definition
    echo  "deleted  config-ecs-task-definition stack"

    echo  "Deleting ecs-cluster"
    aws cloudformation delete-stack --stack-name ecs-cluster
    aws cloudformation wait stack-delete-complete --stack-name ecs-cluster
    echo  "deleted  ecs-cluster stack"

    echo  "Deleting network-stack"
    aws cloudformation delete-stack --stack-name network-stack
    aws cloudformation wait stack-delete-complete --stack-name network-stack
    echo  "deleted network-stack."

    echo "AWS CloudFormation stacks deletion completed."
else
    echo "No action taken. Exiting."
fi

