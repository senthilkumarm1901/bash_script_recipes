#!/bin/bash

# usage:
## bash search_string.bash -f filename -s search_string -r replacement_string

###############################################################
# Main Functions #
###############################################################

function search_n_replace_the_string()
{
	search_string="$1"
	replacement_string="$2"
	full_file_path="$3"
    echo "$search_string" 
    echo "$replacement_string"
	sed -i'.original' -e "s|$search_string|$replacement_string|g" $full_file_path
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            filename="$2"
            shift 2
            ;;
        -s)
            search_string="$2"
            shift 2
            ;;
        -r)
            replacement_string="$2"
            shift 2
            ;;            
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

search_n_replace_the_string "$search_string" "$replacement_string" "$filename"