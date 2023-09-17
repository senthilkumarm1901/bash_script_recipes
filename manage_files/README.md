# Search Operations 

## 1. Search File


### Add the `managae_files.bash` to path and make it executable as `manage_files` anywhere

```bash
bash_script_recipes/manage_files % path_to_script="$PWD/manage_files.bash"
bash_script_recipes/manage_files % phrase_command_to_access_it_in_terminal="manage_files"
bash_script_recipes/manage_files % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash
/any/where/in/terminal % manage_files --count_files_inside_dir "/some/long/path/"
Number of files in /some/long/path/:        5

/any/where/in/terminal % manage_files --backup_file "/some/long/path/la-riots.csv"
Backup created: /some/long/path//la-riots.csv.20230904185300

/any/where/in/terminal % manage_files --get_size "/some/long/path/" 
Size of directory : 681M

/any/where/in/terminal % manage_files --split_file_into_n_chunks "/some/long/path/yelp_review_full_csv/train.csv" 2 "split"
The number of chunks: 2
The file to split: /some/long/path/yelp_review_full_csv/train.csv
Outputs are saved as: /some/long/path/yelp_review_full_csv/split
The new files are:
splitaa
splitab

/any/where/in/terminal % manage_files --split_file_based_on_size "/some/long/path/train.csv" 100M "split"
The size of split file: 100M
The file to split: /some/long/path/train.csv
Outputs are saved as: /some/long/path/split
The new files are:
splitaa
splitab
splitac
splitad
splitae
```
