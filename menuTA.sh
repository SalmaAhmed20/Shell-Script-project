#!/bin/bash
function MenuTable {
    while [ true ]; do
        echo "1.Create Table"
        echo "2.List Tables"
        echo "3.Drop Table"
        echo "4.Insert into Table"
        echo "5.Select from Table"
        echo "6.Delete from Table"
        echo "7.Update Table"
        echo "8.Main Menu"
        curr=$(basename $(pwd))
        read -p "DB/$curr>>" option
        case $option in
            1) echo "Create Table" ; ./../../TableFunctions/createTable.sh ;;
            2) echo "List Tables"  ; ./../../TableFunctions/listTable.sh ;;
            3) echo "Drop Table"  ;;
            4) echo "Insert into Table" ; ./../../TableFunctions/insert.sh ;;
            5) echo "Select from Table"; ./../../TableFunctions/select.sh ;;
            6) echo "Delete from Table"; ./../../TableFunctions/deleteTable.sh;;
            7) echo "Update from Table";;
            8) cd .. ; ./../menuDB.sh ;;
            *) echo "Invalid option";;
        esac
    done
}
MenuTable