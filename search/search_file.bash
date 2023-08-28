#!/bin/bash

# usage:
## bash 1.search_file.bash -f filename -d dirname
## bash 1.search_file.bash -f filename

###############################################################
# Main Function #
###############################################################

function search_file_in_a_dir()
{
	find "$1" -type f -name "$2" 2>/dev/null
}


###############################################################
# How to run this bash script #
###############################################################

# empty line for better printing in terminal
echo 

if [ $# -eq 4 ]; then
    if [ "$1" == "-f" ] && [ "$3" == "-d" ]; then
        search_file_in_a_dir "$4" "$2" 
    elif [ "$1" == "-d" ] && [ "$3" == "-f" ]; then
        search_file_in_a_dir "$2" "$4"
    else
        echo "Invalid arguments. Usage: $0 -f filename -d dirname OR $0 -f filename"
        exit 1
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" == "-f" ]; then
        echo "No direcory was specified. "
        echo -n "Searching for file inside all sub-directories under $HOME ... "
        search_file_in_a_dir "$HOME" "$2" 
    else
        echo "Invalid arguments. \nUsage:\n$0 -f filename OR\n$0 -d dirname OR $0 -f filename"
        exit 1
    fi
else
    echo "Invalid number of arguments. Usage: $0 -f filename -d dirname OR $0 -f filename"
    exit 1
fi