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
	num_of_chunks=$2
	file_to_split=$1
    file_path=$(echo $file_to_split | rev | cut -d'/' -f2- | rev)
	output_prefix=$3
    echo "The number of chunks: $num_of_chunks" 
    echo "The file to split: $file_to_split"
    echo "Outputs are saved as: $file_path/${output_prefix}"
	split -n $num_of_chunks $file_to_split "$file_path/${output_prefix}"
    echo "The new files are:"
    ls $file_path | grep "$output_prefix"
}

# the below functions are hardcoded for better understandability
function split_file_based_on_size()
{
	any_file=$1
	max_split_file_size=$2 #100K 50M 2G refer to KB, MB and GB
    file_path=$(echo $any_file | rev | cut -d'/' -f2- | rev)
    output_prefix=$3
    echo "The size of split file: $max_split_file_size" 
    echo "The file to split: $any_file"
    echo "Outputs are saved as: "$file_path/${output_prefix}""
	split -b $max_split_file_size $any_file "$file_path/${output_prefix}"
    echo "The new files are:"
    ls $file_path | grep "$output_prefix"
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
        direcory=$(echo "$2" | sed "s| |?|g")
        count_files_inside_dir $direcory         
            ;;
        --backup_file)
        file=$(echo "$2" | sed "s| |?|g")
        backup_file "$file"
            ;;
        --get_size)
        get_size "$2"
            ;;
        --split_file_into_n_chunks)
        split_file_into_n_chunks "$2" $3 "$4"
            ;;            
        --split_file_based_on_size)
        split_file_based_on_size "$2" $3 "$4"
            ;;
        --join_files) 
        join_files "$2" "$3"
            ;;
        *)
        echo "Unknown option: $1"
        exit 1
            ;;
    esac
fi