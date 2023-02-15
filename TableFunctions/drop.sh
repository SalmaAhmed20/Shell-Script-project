function dropTable {
    read -r -p "Enter Table Name " Tname
    if [[ -f $Tname && -f "${Tname}_meta" ]]
    then
        rm $Tname "${Tname}_meta"
    else
        echo "----No Such Table with Name: \"$Tname\" ----"
    fi
}
dropTable