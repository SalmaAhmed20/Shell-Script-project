#!/bin/bash
function CreateDB {
    read -p "Enter Database Name: " DBname
    if [[ $DBname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z$]{,63}$ ]]; then
        if [[ $DBname == *[_$] ]]; then
            echo "Not Valid DB name"
        else
            if [ -d "$DBname" ]; then
                echo "database already exist"
            else
                mkdir $DBname
            fi
        fi
    else
        echo "Not valid name"
    fi
    ./../menuDB.sh

}
CreateDB
