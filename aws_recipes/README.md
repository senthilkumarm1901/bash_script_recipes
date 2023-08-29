- The methodology to make `manage_multiple_aws_accounts` work anywhere in terminal is slightly different than the rest of the functions
- This because every time a shell script is run, it makes a copy of current shell and kills that shell onces the shell script is executed.
- But we want the environment variables to persist in our current shell window
- Hence add the below bash function to `~/.zshrc`. 

```bash
manage_multiple_aws_accounts()
{
    source /Users/senthilkumar.m/my_learnings/bash_script_recipes/aws_recipes/manage_multiple_aws_accounts.bash
    recieve_and_verify_clipboard_contents 
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
    echo -n "You have chosen Region:"
    echo $region_name
}
```

- This function `manage_multiple_aws_accounts` is sourced in every new terminal. It executes the commands in `create_aws_environment_variables` in every terminal and hence persisting the environment variables like `REGION`, `AWS_PROFILE`, `AWS_ACCOUNT_ID` in `manage_multiple_aws_accounts.bash` in your current terminal



### Run the script (this is as usual)

```bash
# keep the AWS Credentials copied 
# from your aws_sso_start url like https://my-sso-portal.awsapps.com/start
any/location/in/your/terminal % manage_multiple_aws_accounts --region ap-south-1

Copied Credentials successfully
AWS PROFILE: 123456789_DevOps-Engineer
Logging into the AWS ACCOUNT: 123456789
You have chosen Region: ap-south-1
```

