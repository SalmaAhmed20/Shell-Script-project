#!/bin/bash
function updateEntireColumn
{
 meta="${1}_meta"
    datatypes=()
    tName=$1
    while [[ true ]]; do
        typeset -i idx=0
        typeset -i flag=0
        for line in `cat $meta`
        do
            field=$line
            if [[ flag -ne 0 ]]
            then 
            if [[ $field != "-i" && $field != "-s" && $field != "pk" ]]
            then
                echo $(($idx))")""$field"
            else
                datatypes=(${datatypes[@]} "${field}")
            fi
            fi
            flag=1
        done
        echo $(($idx+1))")""Go Back"
        idx=$idx+1
        curr=$(basename $(pwd))
        read -p "DB/$curr/${1}>>" opt
        temp=$(($idx+1))
        if [[ $opt -le 0 || $opt -gt $temp ]]
            then
                echo "Not valid"
                continue
            else
                if [ $opt -eq $idx ]; then
                 echo "------cancel current updating process------"
                 break    
                fi
                temp=$(($opt-1))
            if [[ ${datatypes[$temp]} = "-i" ]]
            then
                typeset -i data
                read -p "update columns set " data
                    if [[ $data =~ ^[0-9]+$ ]]
                    then
                    fi
            fi
        fi
    done   
}
function updateTable {
    read -p "Enter Table Name:  " Tname
    if [[ $Tname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z]{,31}$ ]]
    then
        if [[ -f $Tname  ]]
        then
            while [ true ]
            do
                echo "1) Update Entire column"
                echo "2) Update Specific Rows"  #delete by any column
                echo "3) Go Back"
                curr=$(basename $(pwd))
                read -p "DB/$curr/${Tname}>> " option
                case $option in
                    1) updateEntireColumn $Tname ;;
                    2) updateSpecific $Tname ;;
                    3) ./../../menuTA.sh;;
                    *) echo "not supported"
                esac
            done
        else
            echo "----No such table named $Tname -----"
        fi
    fi
}
updateTable