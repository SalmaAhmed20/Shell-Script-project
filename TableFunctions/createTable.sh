#!/bin/bash
function CreateTable {
    typeset -i number_fields=0
    typeset -i iterator=1
    
    read -p "Enter Table Name: " Tname
    # check for regex
    if [[ $Tname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z$]{,63}$ ]]
    then
        # check for existance
        if [[ -f "$Tname" ]]; then
            echo "Table \"$Tname\" is already exist."
        else
            read -p "Enter Number of Fields: " number_fields
            if [ $number_fields -le 0 ]
            then
                echo "Number of Fields must be greater than 0"
            else
                while [ $iterator -le $number_fields ];
                do
                    if [ $iterator -eq  1 ];
                    then
                        read -p "Enter Field #1 [NOTICE IT'S YOUR PK]: " fName
                    else
                        read -p "Enter Field #$iterator: " fName
                    fi
                    
                done
            fi
            
        fi
    fi
    ./../../menuTA.sh
}
CreateTable