#!/bin/bash

# usage:
## bash add_a_bash_script_to_bashrc.bash \
##  /path/to/dir/the_particular_bash_script.bash 
##  "phrase_command_to_access_it_in_terminal"

path_to_script=$1
phrase_command_to_access_it_in_terminal=$2

chmod u+x $path_to_script
echo "Adding $path_to_script to path ..."
echo "alias $phrase_command_to_access_it_in_terminal=$path_to_script" >> ~/.zshrc 
# if you are not using macos, change it ~/.bashrc (you can find your bash by trying `echo $SHELL`)