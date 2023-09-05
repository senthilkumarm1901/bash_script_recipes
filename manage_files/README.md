# Search Operations 

## 1. Search File


### Add the `managae_files.bash` to path and make it executable as `manage_files` anywhere

```bash
bash_script_recipes/manage_files % path_to_script="$PWD/manage_files.bash"
bash_script_recipes/manage_files % phrase_command_to_access_it_in_terminal="manage_files"
bash_script_recipes/manage_files % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash


```
