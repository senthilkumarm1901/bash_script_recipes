#!/bin/bash

# usage:
## bash manage_files.bash --function_name arg1 arg2

# functions below are run as 
# func_name arg1 arg2 ...

function count_files_inside_dir() 
{
       directory="$1"
       num_files=$(ls -l "$directory" | grep -v "^d" | wc -l)
       echo "Number of files in $directory: $num_files"
}

function backup_file() 
{
   file_full_path="$1"
   timestamp=$(date +"%Y%m%d%H%M%S")
   cp "$file_full_path" "$file_full_path.$timestamp"
   echo "Backup created: $file_full_path.$timestamp"
}

function get_size() 
{
   file_or_dir="$1"
   if [ -f "$file_or_dir" ]; then
	   size=$(du -sh "$file_or_dir" | awk '{print $1}')
	   echo "Size of $file: $size"
   elif [ -d "$file_or_dir" ]; then
	   size=$(du -sh "$file_or_dir" | awk '{print $1}')
	   echo "Size of directory $file: $size"
   else
	   echo "$file not found or is not a regular file or directory."
   fi
}

function split_file_into_n_chunks()
{
	num_of_chunks=$1
	file_to_split=$2
	output_prefix=$3
	split -n $num_of_chunks $file_to_split $output_prefix
}

# the below functions are hardcoded for better understandability
function split_file_based_on_size()
{
	any_file=$1
	max_split_file_size=$2 #100K 50M 2G refer to KB, MB and GB
	split -b $max_split_file_size $any_file "part_"
}

function join_files()
{
	files_prefix=$1
    complete_file_name=$2
	cat $files_prefix  > $complete_file_name
}

if [[ $# -gt 0 ]]; then
    case "$1" in
        --count_files_inside_dir)
        count_files_inside_dir $2            
            ;;
        --backup_file)
        backup_file $2
            ;;
        --get_size)
            get_size "$2"
            ;;
        --split_file_into_n_chunks)
            split_file_into_n_chunks "$2" "$3" "$4"
            ;;            
        --split_file_based_on_size)
            split_file_based_on_size $1 $2 
            ;;
        --join_files)
            join_files $1 $2 
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
fi