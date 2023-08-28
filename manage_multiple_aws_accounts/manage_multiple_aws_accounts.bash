#!/bin/bash

# usage:
## Ensure you have "copied" the `short term credentials` 
## from your aws_sso_start url like https://my-sso-portal.awsapps.com/start
## bash manage_multiple_aws_accounts.bash --region region_name

function recieve_and_verify_clipboard_contents
{
    clipboard_content=$(pbpaste)
    verify=$(echo $clipboard_content | head -n 2 | tail -n 1 | grep "aws_access_key_id")
    if [ -z $verify]; then
        echo "Your content below in Clipboard are not valid. \
            Please copy the correct short term credentials"
        echo $clipboard_content
    fi
    echo $clipboard_content > ~/.aws/credentials
}

function create_aws_environment_variables()
{
    export REGION=$1
    # typically AWS_PROFILE is a combination like below
    # <AWS_ACCOUNT_ID>_<IAM_ROLE> 
    export AWS_PROFILE=$(cat ~/.aws/credentials | head -n 1 | cut -c 2- | rev | cut -c 2- | rev)
    export AWS_ACCOUNT_ID=$(echo "$AWS_PROFILE" | cut -d'-' -f1)
    aws configure set region $REGION --profile $AWS_PROFILE
}

if [[ $# -gt 0 ]]; then
    case "$1" in
        --region)
            region_name=$2       
            ;;         
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
fi


create_aws_environment_variables $region_name