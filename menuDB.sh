#!/bin/bash
select choice in "Create Database" "List Databases" "Drop Database" "Connect To Databases" "Exit"
do
case $REPLY in 
1) echo "Create"
;;
2) echo "List"
;;
3) ../DBDrop.sh
;;
4) ../DBConnection.sh
;;
5)cd .. ; exec bash ;exit
;;
*) echo "Not Supported"
esac
done