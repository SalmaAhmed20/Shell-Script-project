#!/bin/bash
function CreateDB {
    read -p "Enter Database Name: " name
    if [[ $name =~ ^[a-zA-Z]{1}[_0-9a-zA-Z$]{,63}$ ]]
    then
        if [ -d "$name" ]
        then
            echo "database already exist"
        else
            mkdir $name
        fi
    else
        echo "Not valid name"
    fi
    ./../menuDB.sh
    
}
CreateDB
