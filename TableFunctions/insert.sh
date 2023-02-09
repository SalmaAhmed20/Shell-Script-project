
function checkDataType {
    if [[  "$1" = "-i" ]]
    then
        if [[  "$2" =~ ^[0-9]*$ ]]
        then 
        return 1
        else 
        return 0
        fi
    else
    
        return 1
    fi
}
function readRecord {
    line=""
    # read meta data 
    while read f1 f2 
    do 
        
        read -u 1 -p "Enter $f1 record " record
        if [[ record =~ [:] ]]
        then
        echo "Forbbiden character \":\" "
        else
            if [[ $iterator = 1 ]]
            then 
            echo "true"
            else
            # grep
            echo /
                checkDataType $f2 $record 
                    if [[ $? = 1 ]]
                    then 
                    line+="${record}:"
                    else
                    echo "invalid data type"
                    break
                    fi
            fi
        fi
        
    done  < "${Tname}_meta"
    echo $line >> $Tname
}
function insert {
    read -p "Enter table name " Tname
    if [[ -f $Tname && -f "${Tname}_meta" ]]
        then
        readRecord
                
        else
        echo "No Such Table with Name: \"$Tname\" "
    fi
     
    ./../../menuTA.sh
}
insert