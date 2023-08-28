#!/bin/bash

# usage:
## bash search_string.bash -d dirname -f filename -s search_string
## bash search_string.bash -f filename -s search_string
## bash search_string.bash -f filename

###############################################################
# Main Functions #
###############################################################

function search_a_string()
{
    find "$1" -type f -name "$2" -exec grep -H -n -E "$3" -o {} \;
}

###############################################################
# How to run this bash script #
###############################################################

# empty line for better printing in terminal
echo 

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d)
            dirname="$2"
            shift 2
            ;;
        -f)
            filename="$2"
            shift 2
            ;;
        -s)
            search_string="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z $dirname ]; then
    dirname=$HOME
fi

if [ -z $filename ]; then
    filename="*"
fi

if [ -z $search_string ]; then
    echo "Search String is not provided: $search_string"
fi

search_a_string $dirname $filename $search_string
