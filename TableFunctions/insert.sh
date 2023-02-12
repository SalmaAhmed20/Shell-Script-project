function checkDataType {
    if [[ "$1" = "-i" ]]; then
        if [[ "$2" =~ ^[0-9]*$ ]]; then
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
    if [[ $? = 1 ]]; then
        while IFS=':' read -r f1 f2; do

            if [[ $2 == $f1 ]]; then
                echo "----PrimaryKey Already Exist----"
                return 0
            fi
        done <$Tname
        return 1
    else
        echo "----Invalid DataType----"
        return 0
    fi
}
function readRecord {
    line=""
    iterator=1
    flag=0
    # read meta data
    while read f1 f2; do

        read -u 1 -p "Enter $f1 record " record
        if [[ $record =~ [:] ]]; then
            echo "----Forbbiden character \":\" ----"
            flag=1
            break
        else
            if [[ $iterator = 1 ]]; then
                if [[ -z $record ]]; then
                    echo "---Primary Key Can not be empty---"
                    return
                else
                    checkPK $f2 $record
                    if [[ $? = 1 ]]; then
                        line+="${record}"
                    else
                        return
                    fi
                fi
            else
                if [[ -z $record ]]; then
                    line+=": "
                else
                    checkDataType $f2 $record
                    if [[ $? = 1 ]]; then
                        line+=":${record}"
                    else
                        echo "----invalid data type----"
                        return
                    fi
                fi
            fi
        fi
        iterator+=1

    done <"${Tname}_meta"
    if [[ flag -eq 0 ]]; then
        echo $line >>$Tname
    fi
}

function insert {
    read -p "Enter table name " Tname
    if [[ -f $Tname && -f "${Tname}_meta" ]]; then
        select choice in "Insert Row" Menu Exit; do
            case $REPLY in
            1)
                readRecord
                ;;
            2)
                ./../../menuTA.sh
                break
                ;;
            3)
                exit
                ;;
            *)
                exit
                ;;
            esac
        done

    else

        echo "----No Such Table with Name: \"$Tname\" ----"
    fi

    # ./../../menuTA.sh
}

insert
