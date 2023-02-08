#!/bin/bash
# check for the existance of DBMS folder (Root Folder)
DirExist=$(find ./DBMS -type d -maxdepth 0 2> /dev/null | wc -l )
#it will return 1 if exist "1 Come from 1 wc number of lines Contain specfic word  0 if not exist"
if [[ $DirExist -eq 1 ]]
then
cd "DBMS" 
else
mkdir "DBMS" ; cd "DBMS"
fi
../menuDB.sh