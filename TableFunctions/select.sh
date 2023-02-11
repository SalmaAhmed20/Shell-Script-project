function selectAll {
echo $Tname
echo "----------------------------------------------------"
awk -F " " '{printf $1" : "}' "${Tname}_meta"
echo -e "\n----------------------------------------------------"
sed 's/:/  :  /g' $Tname 
}
function selectByValue {
    
    awk -F " " '{print NR" ) " $1 }' "${Tname}_meta"
    NoOfColumns=`wc -l "${Tname}_meta" | cut -d " " -f1`
    read -p "Enter Column Number" columnNumber
    if [[ $columnNumber =~ ^[0-9]+$ ]]
    then
        
        if ((columnNumber < 1 || columnNumber > NoOfColumns))
        then
        echo "---Invalid Column Number---"
        return
        else
            read -p "Enter Value " value 
            #get all row
            awk -F : -v cn="$columnNumber" -v v="$value" '{
                if($cn == v) 
                print $0;
            }' $Tname
            
        fi
    else
    echo "---Invalid Format---"
        
    fi
}

function selectColumn {
    awk -F " " '{print NR" ) " $1 }' "${Tname}_meta"
    NoOfColumns=`wc -l "${Tname}_meta" | cut -d " " -f1`
    read -p "Enter Column Number" columnNumber
    if [[ $columnNumber =~ ^[0-9]+$ ]]
    then
        
        if ((columnNumber < 1 || columnNumber > NoOfColumns))
        then
        echo "---Invalid Column Number---"
        return
        else
            
            awk -F : -v cn="$columnNumber" '{
                print $cn;
            }' $Tname
            
        fi
    else
    echo "---Invalid Format---"
        
    fi
}
function selectTable {
    read -p "Enter Table Name " Tname
    if [[ -f $Tname && -f "${Tname}_meta" ]]
    then
        select choice in "Select All Data" "Select by value" "Select specific column" Exit
        do
        case $REPLY in
        1 ) selectAll ;;
        2 ) selectByValue ;;
        3 ) selectColumn ;;
        4 ) exit ;;
        * ) exit ;;
        esac
        done
    else
        echo "----No Such Table with Name: \"$Tname\" ----"
    fi
}
selectTable