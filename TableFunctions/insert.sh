
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
function checkPK {
    checkDataType $1 $2
    if [[ $? = 1 ]]
    then
    while IFS=':' read -r f1 f2
    do
       
        if [[ $2 == $f1 ]]
        then
        echo "----PrimaryKey Already Exist----"
        return 0
        fi
    done < $Tname
    return 1
    else
    echo "----Invalid DataType----"
    return 0
    fi
}
function readRecord {
     line=""
     iterator=1;
    # read meta data 
    while read f1 f2 
    do 
        
        read -u 1 -p "Enter $f1 record " record
        if [[ record =~ [:] ]]
        then
        echo "----Forbbiden character \":\" ----"
        else
            if [[ $iterator = 1 ]]
            then 
            checkPK $f2 $record 
                if [[ $? = 1 ]]
                    then 
                    line+="${record}:"
                    else
                    
                    break
                fi
            else
            
            
                checkDataType $f2 $record 
                if [[ $? = 1 ]]
                then 
                line+="${record}:"
                else
                echo "----invalid data type----"
                break
                fi
            fi
        fi
        iterator+=1
        
    done  < "${Tname}_meta"
    echo $line >> $Tname
}

function insert {
    read -p "Enter table name " Tname
    if [[ -f $Tname && -f "${Tname}_meta" ]]
        then
        readRecord
                
        else
        echo "----No Such Table with Name: \"$Tname\" ----"
    fi
     
    ./../../menuTA.sh
}

insert