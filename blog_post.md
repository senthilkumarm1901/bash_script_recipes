# Bash Script Recipes - One of Your Secret Sauces to Improved Productivity

Bash Scripting can improve the productivity of a gamut of professionals not just techies like DevOps, SysAdmin, Networking, ML or Cloud Engineers. It can aid product owners, scrum masters, HR professionals and even time-crunched CXOs to do their repetitive tasks faster. 

Table of Contents
- I. Introduction
- II. Bash Recipes
- III. NL2Bash
- IV. Concluding Remarks
## I.Introduction

### I.A. Why Bash Scripting

Everyone of us deals with files and directories. We search/move/delete/copy files. We look for a particular file or directory. We may even want to search a word/phrase in the files. With Bash, we can do those tasks at scale and at great speed. 

### I.B.  Why Bash Script Recipes
- Create your own simplified bash recipes for tasks that you do repetitively. The recipes could string together several bash commands underneath, but you have abstracted them for quick use

### I.C.  What is in it for you 
The bash script recipes discussed here are intended for 2 purposes. The reader can
1. directly use the recipes in their day-to-day work (like a mini cookbook)
2. learn the fundamentals to create their own recipes 

### I.D. Prerequisites
- Please overcome reluctance to use terminal, if any (I had to!)
- Some really basic bash scripting knowledge (like what is Bash and what is a linux kernel. Refer [here](https://senthilkumarm1901.quarto.pub/learn-by-blogging/posts/2023-08-03-I-Shell-Scripting.html#ii.-a-brief-intro-to-bash-scripting) if interested)

---

## II.  The Bash CLI Recipes

Generic Recipes for everyone
1. `search_file` & `search_file_with_regex`
2. `search_string_with_regex`  & `search_n_replace_with_string`
3. `manage_files`: `split_files` , `count_files`, `backup_files` , `get_file_size`
4. `inside_csv`: `display_column_names`, `display_n_rows_in_a_column` `basic_conditional_operations`
5. BONUS Recipes 

Each of the recipe has the following details:
- Core Function(s)
- Learnings
- How to run it as a bash command

You can always use your own data to run the recipes. 
If you would like to replicate what I have, follow below instructions. 
For sections II.1 and II.2, we are using using [this github repo](https://github.com/PacktPublishing/Bash-Cookbook/tree/master)  as dataset to play with
- Download the data as follows

```bash
# in any new directory of yours
mkdir -p dir_to_run_bash_scripts && cd dir_to_run_bash_scripts
curl -L https://github.com/PacktPublishing/Bash-Cookbook/archive/refs/heads/master.zip -O && mv master.zip Bash-Coolbook.zip
unzip Bash-Coolbook.zip
```

For section II.4, use [this csv file](https://github.com/altair-viz/vega_datasets/blob/master/vega_datasets/_data/la-riots.csv) is used:

```bash
curl https://github.com/altair-viz/vega_datasets/blob/master/vega_datasets/_data/la-riots.csv >> la-riots.csv
```
### II. 1.  Searching Files

`search_file`

**Core Function** in the bash script `search_file.bash`

```bash
function search_file_in_a_dir()
{
	find "$1" -type f -name "$2"
}
```

**Learnings**:

```md
- `find` allows to search for a file recursively under every dir in a specific dir 
- Parameters such as  are passed to functions as positional arguments
```

**How to run the bash script as a command**: (refer README here)

```bash
% search_file -d ./dir_to_search -f "*partial_file_to_search*"
% search_file -f "some_partial_file_name*" # OR search_file -f "full_file_name"
```

For **full recipe details** and bash outputs, refer here

---


`search_file_with_regex`

**Core Functions** in the bash script `search_file_with_regex.bash`

```bash
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
	1_search_file_in_a_dir $1 | 2_to_treat_space_in_file_path | 3_isolate_the_file_name | 4_run_regex_file_search $2
}

# in one line, the above command is 
# find "$1" -type f |  sed "s| |?|g" | rev | cut -d'/' -f1 | rev | grep -E "$2"
```

**Learnings**:

```md
- Note the piping ( | ) in the main function `search_regex_file_in_a_dir` 
- There may be space in a file path. E.g.: "/path/to/an amazing dir/a file name.csv"
- `sed` (streaming editor) is introduced here to `find_and_replace` `a space` as we we are parsing the output of `find` which could have space
- `3_isolate_file_name` function isolates the filename in the end by the dir separator "/" 
	- If you are using Windows, god help you :). Kidding, I am hoping you'd use WSL. 
- `grep -E` allows for execution of regex filtering on the previous output we have piped
- In a regex search, [ . * ( ) ] + are metacharacters. If you need to match them as is, escape with a backslash. E.g.: "[0-9]+_[a-z]+\.sh" will match a file_name like "02_some_file_name.sh"
- While you can use "*" in `search_file` but not here `search_file_with_regex`
```

**How to run the bash script as a command**: (refer README here)

```bash
# if you know the source directory where to search
% search_file_with_regex -d ./dir_to_search -rf "[0-9]+_[a-z]+\.sh"
# if you do not know the directory where to search, we will search from $HOME
% search_file_with_regex -rf "some_regex_pattern" 
```

For **full recipe details** and bash outputs, refer here

---

### II. 2. Searching Strings

`search_string`

**Core Function**

```bash
function search_a_string()
{
    find "$1" -type f -name "*" -exec grep -H -n -E "$2" -o {} \;
}
```

**Learnings**:

```md
- Do note the use of `-exec` which will direct grep to search inside every matching file from `find`
- `grep -n` gives out number of line that matches
- `grep -o` outputs the matched string
- `grep -E` allows "Extended" Regex patterns as input 
```

**How to run the bash script as a command**: (refer README here)

```bash
# do note, it need not be just regex_pattern search, even a normal word as is will also be fetched
% search_string -d dir_name -f file_name -rs regex_search_string
# if you do not know directory or type of file, you can simply do the below search string itself
% search_string -rs regex_search_string
```

For **full recipe details** and bash outputs, refer here

<hr>

``
`search_n_replace_strings`

**Core Function**:

```bash
function search_a_string()
{
	find "$1" -type f -name "$2" -exec grep -H -E "$3" -o {} \;
}

function isolate_file_name_and_string()
{
	file_name_with_path=$(echo "$1" | cut -d':' -f1) 
	escaped_file_name_with_path=$(printf '%q' "$file_name_with_path")
	string_to_match=$(echo "$1" | cut -d':' -f2)
	result=("$escaped_file_name_with_path" "$string_to_match")
}

function replace_the_string()
{
	search_string="$1"
	replacement_string="$2"
	file_path="$3"
	sed -i '' 's|${search_string}|${replacement_string}|g' $file_path
}

function main_function()
{
	dir_name="$1"
	file_name="$2"
	search_pattern="$3"
	replacement_string="$4"
	
	result1=$(search_a_string $dir_name $file_name $search_pattern)
	result2=$(isolate_file_name_and_string $result1)
	file_path="${result2[1]}"
	search_string="${result2[2]}"
	replace_the_string $search_string $replacement_string $file_path
}
```

**Learnings**:

```md
- Note the use of two `-exec` commands and 2 curly brackers ( {} ) to use the output from previous stage and pass as input to next command
- `sed -i ''`` command replaces the file in-place and leaves no backup. If you want a backup, you could give something like this `sed -i '.backup'`
```

**How to run the bash script as a command**: (refer README here)

```bash
# do note, it need not be just regex_pattern search, even a normal word as is will also be fetched
% search_n_replace_strings -d dir_name -f file_name --search_string regex_search_string -replacement_string replacement_string
# if you do not know directory or type of file, you can simply do the below search string itself
% search_n_replace_strings --search_string regex_search_string -replacement_string replacement_string
```

For **full recipe details** and bash outputs, refer here

---

### III. Manage files

`manage_files`

Core Functions

```bash
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
   file="$1"
   timestamp=$(date +"%Y%m%d%H%M%S")
   cp "$file" "$file.$timestamp"
   echo "Backup created: $file.$timestamp"
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
	any_file=sample_file.zip
	max_split_file_size=50M #100K 50M 2G refer to KB, MB and GB
	split -b $max_split_file_size $any_file "part_"
}

function join_files()
{
	files_prefix="part_*"
	cat $files_prefix  > sample_file_regrouped.zip
}
```

**Learnings**:

```md
- The commands we have covered here include 
	- a combination of list dir command `ls`, `grep "^d"` (anything but a directory) and word count by line `wc -l`
	- backup based on time using `date` and `cp`
	- conditions like `[ -d $file_or_dir]`  to detect if the value is a directory
	- `split` and `cat`
```

**How to run the bash script as a command**: (refer README here)

```bash
# inside the recipe, there will be a if clause to direct to the right function
# refer full recipe for details
% manage_files --function_name arg1 arg2
# You can also add any number of other file operations that you want to club with `manage_files`
```

For **full recipe details** and bash outputs, refer here

---
### II.4 Inside CSV


`inside_csv`

```bash
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

# the below functions are hard-coded for better understandability
# can your count the number of rows where gender=="Male"
function basic_text_conditional_operation()
{
	file_name="la-riots.csv"
	column_name="gender"
	specific_column_number=$(head -n 1 $file_name | sed 's|,|\n|g' | nl | grep "$column_name" | grep -E "[0-9]+" -o)
	num_of_males=$(awk -F',' -v column_number=$specific_column_number '$column_number=="Male" { print }' $file_name | wc -l)
	echo "Number of males: $num_of_males"
}

function basic_arithmetic_condition()
{
	file_name="la-riots.csv"
	column_name="age"
	specific_column_number=$(head -n 1 $file_name | sed 's|,|\n|g' | nl | grep "$column_name" | grep -E "[0-9]+" -o)
	age_gt_18=$(awk -F',' -v column_number=$specific_column_number '$column_number >= 18 { print }' $file_name | wc -l)
	echo "Num of ppl greater than or equal to 18: $age_gt_18"
}

```


**Learnings**:

```md
- We have used primarily `awk` to parse inside files
- `awk` uses column_number as input. We infer column_number from column_name using `sed`, `nl` and `grep`
```

**How to run the bash script as a command**: (refer README here)

```bash
# inside the recipe, there will be a if clause to direct to the right function
# refer full recipe for details
% inside_csv --function_name arg1 arg2
# You can also add any number of other file operations that you want to club with `manage_files`
```

For **full recipe details** and bash outputs, refer here



----

### BONUS

BONUS: Coder-specific Recipes that I use regularly (not discussed in depth; just for you to use !)
1. `manage_multiple_aws_accounts`  | link
2. `search_python_environments` | link
3. `manage_docker` | link

---

## III. Natural Language 2 Bash (NL2Bash) using LLMs, an interesting frontier ...


1. If you are not constrained by budget, a paid Large Language Model based option is possible for productional use. Do explore  [AI-Shell](https://github.com/BuilderIO/ai-shell) and [Yolo](https://github.com/wunderwuzzi23/yolo-ai-cmdbot/tree/main) , powered by ChatGPT. 
2. If you want a fully local and free* version, then a Fine-tuning a OpenSource LLM could also be possible. In fact, we could build restricted Bash scope (so that not anything and everything is allowed to be executed)
\*nothing is free; Fine-tuning a opensource LLM locally needs compute resources

If you have a server and there is a solid case for giving users/developers a Natural Language way of accessing information, the NL2Bash is a really good option.  
In fact, in the same API, NL2Py or NL2SQL can also be implemented. For the user, it is is just NL that they interact with.

This space is truly exciting. However, if you are not going to run too varied a list of bash commands, then a NL option is still like a bulldozer to mow a lawn. You are better off mowing the old-fashioned way with custom Bash recipes like above which leave no memory footprint and are blazing fast. 

---

## IV. Concluding Remarks

At its core, the bash script recipes discussed here consist of just a simple transformation

```bash
function a_specific_function()
{
	# some simple transformation
}
```

Arguable opinion: bash scripting is meant for implementation the above way. 
It is NOT a replacement for Python or Rust or even a [Taskfile](https://taskfile.dev/). But in combination with your core programming language, they are really powerful. 

If I take some technical liberty, you did not execute bash scripting when you used `find` , `grep`, `sed` and `awk`, you actually leveraged really efficiently written C codes (source). 

Bash scripting is foundational to Software Engineering and more pervasive than you think. If you have used `git`, `docker`, `kubectl` or even just `mkdir & cd`, you have tip-toed into bash scripting. 

Unequivocally, it is a good skill in your toolbox. 
Happy Bash Scripting !

---
