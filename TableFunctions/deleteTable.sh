#!/bin/bash
function deleteSpecific {
    fields=$(cut -d "-" -f1 "${1}_meta") 
    echo $fields
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
                echo "2) Delete Specific Row "
                echo "3) Go Back"
                read -p ">>" option
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