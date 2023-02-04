#!/bin/bash
function ListDBs {
   if [[ -z $(ls -d */ 2> /dev/null | cut -f1 -d'/' ) ]] 
   then
        echo "No Database exist"
   else
        ls -d */ | cut -f1 -d'/'
   fi
    ./../menuDB.sh

}
ListDBs