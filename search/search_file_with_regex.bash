#!/bin/bash

# usage: 
# % search_file_with_regex -d path/to/dir_to_search -rf "[0-9]+_[a-z]+\.sh"

# if you do not know the directory where to search, we will search from $HOME
# % search_file_with_regex -rf "some_regex_pattern" 


###############################################################
# Main Functions #
###############################################################

function 1_search_file_in_a_dir()
{
	find "$1" -type f
}

function 2_to_treat_space_in_file_path()
{
	sed "s| |?|g"
}

function 3_isolate_file_name()
{
	rev | cut -d'/' -f1 | rev
}

function 4_run_regex_file_search()
{
	grep -E "$2"
}

function main_function()
{
	1_search_file_in_a_dir $1 | 2_to_treat_space_in_file_path | 3_isolate_file_name | 4_run_regex_file_search $2
}

# in one line, the above command is 
# find "$1" -type f |  sed "s| |?|g" | rev | cut -d'/' -f1 | rev | grep -E "$2"


###############################################################
# How to run this bash script #
###############################################################

# empty line for better printing in terminal
echo 

if [ $# -eq 4 ]; then
    if [ "$1" == "-rf" ] && [ "$3" == "-d" ]; then
        main_function "$4" "$2" 
    elif [ "$1" == "-d" ] && [ "$3" == "-rf" ]; then
        main_function "$2" "$4"
    else
        echo "Invalid arguments. Usage: $0 -rf filename -d dirname OR $0 -rf filename"
        exit 1
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" == "-rf" ]; then
        echo "No direcory was specified. "
        echo -n "Searching for file inside all sub-directories under $HOME ... "
        main_function "$HOME" "$2" 
    else
        echo "Invalid arguments. \nUsage:\n$0 -f filename OR\n$0 -d dirname OR $0 -f filename"
        exit 1
    fi
else
    echo "Invalid number of arguments. Usage: $0 -f filename -d dirname OR $0 -f filename"
    exit 1
fi