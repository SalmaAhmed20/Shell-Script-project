#!/bin/bash
select choice in "Create Database" "List Databases" "Drop Database" "Connect To Databases" "Exit"
do
case $REPLY in 
1) ../DBFunctions/DBCreate.sh
;;
2) ../DBFunctions/DBList.sh
;;
3) ../DBFunctions/DBDrop.sh
;;
4) ../DBFunctions/DBConnection.sh
;;
5)cd .. ; exec bash ;exit
;;
*) echo "Not Supported"
esac
done