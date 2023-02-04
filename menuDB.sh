#!/bin/bash
select choice in "Create Database" "List Databases" "Drop Database" "Connect To Databases"
do
case $REPLY in 
1) echo "Create"
;;
2) echo "List"
;;
3)echo "Drop"
;;
4) echo "Connect"
;;
*) echo "Not Supported"
esac
done