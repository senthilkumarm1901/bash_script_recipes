#!/bin/bash

# usage:
## bash inside_csv.bash --function_name arg1 arg2

# `display_column_names`, `display_n_rows_in_a_column` `basic_conditional_operations`

function display_column_names()
{
	file_name=$1
	head -n 1 $file_name | sed 's|,|\n|g'
}

function display_n_rows_in_a_column()
{
	file_name=$1
	column_name=$2
	num_rows=$3
	specific_column_number=$(head -n 1 $file_name | sed 's|,|\n|g' | nl | grep "$column_name" | grep -E "[0-9]+" -o)
	awk -F',' -v column_number=$specific_column_number '{print $column_number}' $file_name | head -n num_rows
}

function filter_a_text_column()
{
	file_name=$1
	column_name=$2
    text_to_filter=$3
	specific_column_number=$(head -n 1 $file_name | sed 's|,|\n|g' | nl | grep "$column_name" | grep -E "[0-9]+" -o)
	num_of_males=$(awk -F',' -v column_number=$specific_column_number '$column_number=="$text_to_filter" { print }' $file_name | wc -l)
	echo "Number of males: $num_of_males"
}

function filter_a_numeric_column()
{
	file_name=$1
	column_name=$2
    numeric_column_condition=$3 # something like ">= 18"
	specific_column_number=$(head -n 1 $file_name | sed 's|,|\n|g' | nl | grep "$column_name" | grep -E "[0-9]+" -o)
	age_gt_18=$(awk -F',' -v column_number=$specific_column_number '$column_number $numeric_column_condition { print }' $file_name | wc -l)
	echo "Num of ppl greater than or equal to 18: $age_gt_18"
}

if [[ $# -gt 0 ]]; then
    case "$1" in
        --display_column_names)
        display_column_names "$2"            
            ;;
        --display_n_rows_in_a_column)
        display_n_rows_in_a_column "$2" "$3" "$4"
            ;;
        --filter_a_text_column)
            filter_a_text_column "$2" "$3" "$4"
            ;;
        --filter_a_numeric_column)
            filter_a_numeric_column "$2" "$3" "$4"
            ;;            
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
fi