#!/bin/bash
Tables=$(ls --hide=*_meta)  # hide any result  match patter
typeset -i iterator=1
if [[ $Tables ]]
then
for t in $Tables
do
   echo "$iterator) $t"
   iterator=$iterator+1
done
else
echo "------No Tables in \"$(basename $(pwd))\" DataBase ------"
fi
./../../menuTA.sh