function DropDB {
    read -p "Enter Database name: " DBname
    if [[ $DBname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z$]{,63}$ ]]
    then
        if [[ $DBname == *[_$] ]]
        then echo "Not Valid DB name"
        else
            DirExist=$(find "${DBname}" 2> /dev/null | wc -l )
            echo $DirExist
            if [[ $DirExist -ge 1 && ( -d "${DBname}" ) ]]
            then
                rm -r "$DBname"
                ../menuDB.sh
            else
                echo "No Such Database with Name: \"$DBname\" "
            fi
        fi
    else
        echo "Not Valid DB name"
    fi
}
DropDB