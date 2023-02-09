#!/bin/bash
function deleteOneRow {
    fields=$(cut -d "-" -f1 "${1}_meta")
    
    
}
function deleteSpecific {
    meta="${1}_meta"
    declare -a datatypes[]
    while [[ true ]]; do
        typeset -i idx=0
        for line in `cat $meta`
        do
            field=$line
            if [[ $field != "-i" && $field != "-s" && $field != "pk" ]]
            then
                fields[$idx]=$field
                # echo "${fields[$idx]}"
                echo $(($idx+1))")""$field"
                idx=$idx+1
            else
                datatypes[$idx]=$field
                echo  ${datatypes[$idx]}
            fi
        done
        curr=$(basename $(pwd))
        # typeset -i opt=0;
        read -p "DB/$curr/${1}>>" opt
        temp=$(($idx+1))
        if [[ $opt -le 0 || $opt -gt $temp ]]
        then
            echo "Not valid"
            continue
        else
            read -p "Delete Row where " data
            temp=$(($opt-1))
            echo $temp
            echo "i:" ${datatypes[$temp]}

            if [[ $datatypes[$(($opt-1))] = "-i" ]]
            then
                if [[ $data =~ ^[0-9]+$ ]]
                then
                echo $1
                awk -F":" '/$data/ {if ($opt=="${data}") print FNR}' $1
                else
                    echo "Illagel value"
                fi
            else 
                            awk -F":" '/$data/ {if ($opt=="${data}") print FNR}' $1

            fi
        fi
    done
}
function deleteFromTable {
    read -p "Enter Table Name" Tname
    if [[ $Tname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z]{,31}$ ]]
    then
        if [[ -f $Tname  ]]
        then
            while [ true ]
            do
                echo "1) Delete all data"
                echo "2) Delete One Row " #delete by pk and /or another column
                echo "3) Delete Many Rows"  #delete by any column
                echo "4) Go Back"
                curr=$(basename $(pwd))
                read -p "DB/$curr/${Tname}>>" option
                case $option in
                    1) > $Tname ;;
                    2) deleteOneRow $Tname;;
                    3) deleteSpecific $Tname ;;
                    4) ./../../menuTA.sh;;
                    *) echo "not supported"
                esac
            done
        else
            echo "----No such table named $Tname -----"
        fi
    fi
}
deleteFromTable