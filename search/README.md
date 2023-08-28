# Search Operations 

## 1. Search File


### Add the `search_file.bash` to path and make it executable as `search_file` anywhere

```bash
bash_script_recipes/search % path_to_script="$PWD/search_file.bash"
bash_script_recipes/search % phrase_command_to_access_it_in_terminal="search_file"
bash_script_recipes/search % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash
# search files that have the pattern "*function*"
any/location/in/your/terminal % search_file -d "/path/to/dir/Bash-Cookbook-master" -f "*function*"


/path/to/dir/Bash-Cookbook-master/chapter 08/10_function_example.sh
/path/to/dir/Bash-Cookbook-master/chapter 08/11_function2.sh
/path/to/dir/Bash-Cookbook-master/chapter 01/14_function.sh

# search for files (EVERYWHERE*) that are of the pattern "print*.sh"
# EVERYWHERE == under your $HOME
any/location/in/your/terminal % search_file -f "*print*.sh"


No direcory was specified. 
Searching for file inside all sub-directories under /Users/senthilkumar.m ... 
/some/long/path/Bash-Cookbook-master/chapter 02/10_printf-mayhem.sh
/some/long/path/Bash-Cookbook-master/chapter 04/05_loop_and_print.sh
```

<hr>

## 2. Search File with Regex Pattern
### Add the `search_file_with_regex.bash` to path and make it executable as `search_file_with_regex` anywhere

```bash
bash_script_recipes/search % path_to_script="$PWD/search_file_with_regex.bash"
bash_script_recipes/search % phrase_command_to_access_it_in_terminal="search_file_with_regex"
bash_script_recipes/search % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash
# the below code shows all files starting with a number
any/location/in/your/terminal % search_file_with_regex -d "/a/long/path/to/some/dir/Bash-Cookbook-master" -rf "[0-9]+_[a-z]+\.sh"

08_more-strsng.sh
12_translator.sh
15_data-xml-to-json.sh
13_files-extended.sh
06_builtin-strng.sh
01_search.sh
09_echo-mayhem.sh
02_test.sh
11_hellobonjou
...
```
<hr>

## 3. Search a String

### Add the `search_string.bash` to path and make it executable as `search_string` anywhere


```bash
bash_script_recipes/search % path_to_script="$PWD/search_string.bash"
bash_script_recipes/search % phrase_command_to_access_it_in_terminal="search_string"
bash_script_recipes/search % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash
# serch for all files with ".sh" extension 
# and having a function in the format `some_function()`
any/location/in/your/terminal % search_string -d "/some/long/dir/path" -f "*.sh" -s "[a-z_]+\(\)"

/some/long/dir/path/chapter 02/13_files-extended.sh:4:permissions()
/some/long/dir/path/chapter 02/13_files-extended.sh:18:file_attributes()
/some/long/dir/path/chapter 02/13_files-extended.sh:43:dir_attributes()
/some/long/dir/path/chapter 02/13_files-extended.sh:50:checkout_file()
/some/long/dir/path/chapter 02/11_hellobonjour.sh:3:i_have()
/some/long/dir/path/chapter 04/01_recursive_read_input.sh:3:recursive_func()
/some/long/dir/path/chapter 04/11_mytrap.sh:3:setup()
/some/long/dir/path/chapter 04/11_mytrap.sh:8:cleanup()
/some/long/dir/path/chapter 04/13_mytimeout.sh:5:func_timer()
/some/long/dir/path/chapter 04/13_mytimeout.sh:11:clean_up()
....
```

## 4. Search and Replace String

### Add the `search_n_replace_strings.bash` to path and make it executable as `search_n_replace_strings` anywhere


```bash
bash_script_recipes/search % path_to_script="$PWD/search_n_replace_strings.bash"
bash_script_recipes/search % phrase_command_to_access_it_in_terminal="search_n_replace_strings"
bash_script_recipes/search % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```


### Recipe Outputs

```bash
bash_script_recipes/search % vi some_sample_file.sh # edit the file
bash_script_recipes/search % cat some_sample_file.sh # display the file

#!/bin/bash

function recursive_func() {

    echo -n "Press anything to continue loop "
    read input
    recursive_func
}

recursive_func
exit 0

bash_script_recipes/search % search_n_replace_strings -f "some_sample_file.sh" -s "echo -n" -r "printf"

# the original file is saved as some_sample_file.sh.original
bash_script_recipes/search % cat some_sample_file.sh
#!/bin/bash

function recursive_func() {

    printf "Press anything to continue loop "
    read input
    recursive_func
}

recursive_func
exit 0

```