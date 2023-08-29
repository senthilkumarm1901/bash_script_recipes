### Add the `manage_multiple_aws_accounts.bash` to path and make it executable as `manage_multiple_aws_accounts` anywhere

```bash
bash_script_recipes/aws_recipes % path_to_script="$PWD/manage_multiple_aws_accounts.bash"
bash_script_recipes/aws_recipes % phrase_command_to_access_it_in_terminal="manage_multiple_aws_accounts"
bash_script_recipes/aws_recipes % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Run the script

```bash
# keep the AWS Credentials copied 
# from your aws_sso_start url like https://my-sso-portal.awsapps.com/start
any/location/in/your/terminal % manage_multiple_aws_accounts --region ap-south-1

Copied Credentials successfully
AWS PROFILE: 123456789_DevOps-Engineer
Logging into the AWS ACCOUNT: 123456789
You have chosen Region: ap-south-1
```

