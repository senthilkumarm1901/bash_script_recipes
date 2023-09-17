# Search Operations 

## 1. Search File


### Add the `inside_csv.bash` to path and make it executable as `inside_csv` anywhere

```bash
bash_script_recipes/inside_csv % path_to_script="$PWD/inside_csv.bash"
bash_script_recipes/inside_csv % phrase_command_to_access_it_in_terminal="inside_csv"
bash_script_recipes/inside_csv % bash $(dirname $PWD)/add_a_bash_script_to_bashrc.bash $path_to_script $phrase_command_to_access_it_in_terminal && source ~/.zshrc  && exec $SHELL 
```

### Recipe Outputs

```bash
# displaying column names of file `la-riots.csv`
/any/where/in/terminal % inside_csv --display_column_names /some/long/path/la-riots.csv  

first_name
last_name
age
gender
race
death_date
address
neighborhood
type
longitude
latitude

# displaying 5 rows of a column `address` in file `la-riots.csv`
/any/where/in/terminal % inside_csv --display_n_rows_in_a_column /some/long/path/la-riots.csv address 5

address
2009 W. 6th St.
Main & College streets
3100 Rosecrans Ave.
Rosecrans & Chester avenues
1600 W. 60th St.
Rosecrans & Chester avenues


/any/where/in/terminal % inside_csv --filter_a_text_column /some/long/path/la-riots.csv "gender" "Female"
The Results are:

first_name,last_name,age,gender,race,death_date,address,neighborhood,type,longitude,latitude
---
Vivian,Austin,87,Female,Black,1992-05-03,1600 W. 60th St.,Harvard Park,Death,-118.304741,33.985667
Carol,Benson,42,Female,Black,1992-05-02,Harbor Freeway near Slauson Avenue,South Park,Death,-118.2805037,33.98916756
Juana,Espinosa,65,Female,Latino,1992-05-02,7608 S. Compton Ave.,Compton,Homicide,-118.2461881,33.9198205
Betty,Jackson,56,Female,Black,1992-05-01,Main & 51st streets,South Park,Death,-118.2739305,33.9965216
Lucie R.,Maronian,51,Female,White,1992-05-01,1800 block of East New York Drive,Altadena,Homicide,-118.1134357,34.1785051
Suzanne R.,Morgan,24,Female,Black,1992-05-01,2137 E. 115th St.,Watts,Not riot-related,-118.2344108,33.9304917
Juanita,Pettaway,37,Female,Black,1992-04-30,Santa Monica Boulevard & Seward Street,Hollywood,Death,-118.3331771,34.090696
```
