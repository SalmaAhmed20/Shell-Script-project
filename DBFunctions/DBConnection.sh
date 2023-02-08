#!/bin/bash

function ConnectToDB {
    read -p "Enter Database name: " DBname
    if [[ $DBname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z$]{,63}$ ]]
    then
        if [[ $DBname == *[_$] ]]
        then echo "Not Valid DB name"
        else
            DirExist=$(find "${DBname}" -type d -maxdepth 0 2> /dev/null | wc -l )
            if [[ $DirExist -eq 1  ]]
            then
                cd "$DBname"
                ./../../menuTA.sh
            else
                echo "No Such Database with Name: \"$DBname\" "
            fi
        fi
    else
        echo "Not Valid DB name"
    fi
    ./../menuDB.sh
}
ConnectToDB

