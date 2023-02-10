#!/bin/bash
function deleteOneRow {
    fields=$(cut -d "-" -f1 "${1}_meta")
}
function deleteSpecific {
    meta="${1}_meta"
    datatypes=()
    data=""
    tName=$1
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
                datatypes=(${datatypes[@]} "${field}")
                # echo  ${datatypes[$idx]}
            fi
        done
        curr=$(basename $(pwd))
        # typeset -i opt=0;5
        read -p "DB/$curr/${1}>>" opt
        temp=$(($idx+1))
        if [[ $opt -le 0 || $opt -gt $temp ]]
        then
            echo "Not valid"
            continue
        else
            read -p "Delete Row where " data
            temp=$(($opt-1))
            if [[ ${datatypes[$temp]} = "-i" ]]
            then
                if [[ $data =~ ^[0-9]+$ ]]
                then
                    while [[ true ]]; do
                        res=$(awk 'BEGIN{FS=":"}{if ($'$opt'=="'$data'") print $'$data'}' $tName )
                        if [[ $res == "" ]]
                        then
                            if [[ flag == 0 ]]
                            then
                                echo "Value Not Found"
                            fi
                            break
                        else
                            NR=($(awk 'BEGIN{FS=":"}{if ($'$opt'=="'$data'") print NR}' $tName ))
                            sed -i ''$NR'd' $tName
                            flag=1
                        fi
                    done
                else
                    echo "Illagel value"
                fi
            elif [[ ${datatypes[$temp]} = "-s" ]]
            then
                flag=0
                while [[ true ]]; do
                    res=$(awk 'BEGIN{FS=":"}{if ($'$opt'=="'$data'") print $'$data'}' $tName )
                    if [[ $res == "" ]]
                    then
                        if [[ flag == 0 ]]
                        then
                            echo "Value Not Found"
                        fi
                        break
                    else
                        NR=($(awk 'BEGIN{FS=":"}{if ($'$opt'=="'$data'") print NR}' $tName ))
                        sed -i ''$NR'd' $tName
                        flag=1
                    fi
                done
            fi
        fi
        break
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
                echo "2) Delete Many Rows"  #delete by any column
                echo "3) Go Back"
                curr=$(basename $(pwd))
                read -p "DB/$curr/${Tname}>>" option
                case $option in
                    1) > $Tname ;;
                    2) deleteSpecific $Tname ;;
                    3) ./../../menuTA.sh;;
                    *) echo "not supported"
                esac
            done
        else
            echo "----No such table named $Tname -----"
        fi
    fi
}
deleteFromTable