#!/bin/bash
function CreateTable {
    typeset -i number_fields=0
    typeset -i iterator=1
    fName=""
    fieldsName=()
    read -p "Enter Table Name: " Tname
    # check for regex
    if [[ $Tname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z]{,31}$ ]]; then
        # check that table don't end with _
        if [[ $Tname == *[_] ]]; then
            echo "Not Valid Table name"
        else
            # check for existance
            if [[ -f "$Tname" ]]; then
                echo "Table \"$Tname\" is already exist."
            else
                read -p "Enter Number of Fields: " number_fields
                #  it may throw 0 if user enter string
                while [ $number_fields -le 0 ]; do
                    echo "Number of Fields must be greater than 0"
                    read -p "Enter Number of Fields: " number_fields
                done
                touch "${Tname}_meta"
                while [ $iterator -le $number_fields ]; do
                    while [ true ]; do
                        if [ $iterator -eq 1 ]; then
                            read -p "Enter Field #1 [NOTICE IT'S YOUR PK]: " fName
                        else
                            read -p "Enter Field #$iterator: " fName
                        fi
                        if [[ $fName =~ ^[a-zA-Z]{1}[_0-9a-zA-Z]{,31}$ ]]; then
                            # check that field don't end with _
                            if [[ $fName == *[_] ]]; then
                                echo "Not Valid Field name"
                            else
                                break
                            fi
                        else
                            echo "Not Valid Field name"
                        fi
                    done
                    while [ true ]; do
                        echo "1) Integer Data Type"
                        echo "2) String Data Type"
                        read -p ">>" option
                        case $option in
                        1)
                            dt="-i"
                            break
                            ;;
                        2)
                            dt="-s"
                            break
                            ;;
                        *)
                            flag=0
                            echo "not supported"
                            ;;
                        esac
                    done
                    if [[ " ${fieldsName[*]} " =~ " ${fName} " ]]; then
                        echo "Duplicate field name"
                        rm "${Tname}_meta"
                        return
                    fi
                    fieldsName=(${fieldsName[@]} "${fName}")
                    echo "${fName} ${dt}" >>"${Tname}_meta"
                    iterator=$iterator+1

                done
            fi
        fi
        touch "${Tname}"
    else
        echo "Not valid Table name"

    fi
    ./../../menuTA.sh
}
CreateTable