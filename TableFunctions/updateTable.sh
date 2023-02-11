#!/bin/bash
function menu {
    meta="${1}_meta"
    datatypes=()
    tName=$1
    while [[ true ]]; do
        typeset -i idx=0
        for line in $(cat $meta); do
            field=$line
            if [[ $field != "-i" && $field != "-s" && $field != "pk" ]]; then
                echo $(($idx + 1))")""$field"
                idx=$idx+1
            else
                datatypes=(${datatypes[@]} "${field}")
            fi
        done
        echo $(($idx + 1))")""Go Back"
        idx=$idx+1
        curr=$(basename $(pwd))
        echo "------Choose column you want to update------  "
        read -p "DB/$curr/${1}>>" updateCol
        temp=$(($idx + 1))
        if [[ $updateCol -le 0 || $updateCol -gt $temp ]]; then
            echo "Not valid"
            continue
        else
            if [ $updateCol -eq $idx ]; then
                echo "------cancel updating process------"
                break
            fi
            return $updateCol
        fi
    done
}
function updateEntireColumn {
    meta="${1}_meta"
    datatypes=()
    tName=$1
    typeset -i idx=0
    while [[ true ]]; do
        typeset -i flag=0
        for line in $(cat $meta); do
            field=$line
            if [[ flag -ne 0 ]]; then
                if [[ $field != "-i" && $field != "-s" && $field != "pk" ]]; then
                    echo $(($idx + 1))")""$field"
                    idx=$idx+1
                else
                    datatypes=(${datatypes[@]} "${field}")
                    # echo "${datatypes[$idx]}"
                fi
            fi
            flag=1
        done
        echo $(($idx + 1))")""Go Back"
        idx=$idx+1
        curr=$(basename $(pwd))
        read -p "DB/$curr/${1}>>" opt
        if [[ $opt -le 0 || $opt -gt $idx ]]; then
            echo "Not valid"
            continue
        else
            if [ $opt -eq $idx ]; then
                echo "------cancel current updating process------"
                break
            fi
            echo "${datatypes[$opt]}"
            if [[ ${datatypes[$opt]} = "-i" ]]; then
                typeset -i data
                read -p "update columns set " data
                if [[ $data =~ ^[0-9]+$ ]]; then
                    temp=$(($opt + 1))
                    # echo $temp
                    # touch .tmpupdate
                    awk -F ":" '{sub($'$temp','$data'); print $0}' $tName >>.tmpupdate
                    cat .tmpupdate >$tName
                    rm .tmpupdate
                fi
            elif [[ ${datatypes[$opt]} = "-s" ]]; then
                # echo "inn2"
                flag=0
                read -p "update columns set " data2
                if [[ $data2 =~ [:] ]]; then
                    echo "----Forbbiden character \":\" ----"
                else
                    temp=$(($opt + 1))
                    awk -F ":" '{ sub($'$temp','"\"$data2\""'); print $0}' $tName >>.tmpupdate
                    cat .tmpupdate >$tName
                    rm .tmpupdate
                fi
            fi
        fi
        break
    done
}
function updateSpecific {
    meta="${1}_meta"
    datatypes=()
    tName=$1
    while [[ true ]]; do
        typeset -i idx=0
        typeset -i searchCol=0
        for line in $(cat $meta); do
            field=$line
            if [[ $field != "-i" && $field != "-s" && $field != "pk" ]]; then
                echo $(($idx + 1))")""$field"
                idx=$idx+1
            else
                datatypes=(${datatypes[@]} "${field}")
            fi
        done
        echo $(($idx + 1))")""Go Back"
        idx=$idx+1
        curr=$(basename $(pwd))
        echo "------Choose column you want to search by------  "
        read -p "DB/$curr/${1}>>" searchCol
        # echo "search col:"$searchCol
        temp=$(($idx + 1))
        if [[ $searchCol -le 0 || $searchCol -gt $temp ]]; then
            echo "Not valid"
            continue
        else
            if [ $searchCol -eq $idx ]; then
                echo "------cancel updating process------"
                break
            fi
            temp=$(($searchCol - 1))
            if [[ ${datatypes[$temp]} = "-i" ]]; then
                typeset -i data
                read -p "update Row where " data
                if [[ $data =~ ^[0-9]+$ ]]; then
                    while [[ true ]]; do
                        menu $tName
                        res=$?
                        if [ $res -eq 0 ]; then
                            echo "------cancel updating process------"
                            idx=0
                            break
                        fi
                        # check if record exist or not
                        result=$(awk 'BEGIN{FS=":"}{ if ($'$searchCol' == '$data') print $0; else print ""; }' $tName)
                        if [[ $result != "" ]]; then
                            # case of first column it is primary key
                            if [[ $res -eq 1 ]]; then
                                # check type first case of integer
                                temp2=$(($res - 1))
                                echo "ss: ${datatypes[$temp2]} "
                                if [[ ${datatypes[$temp2]} = "-i" ]]; then
                                    read -p "update Row set " val
                                    if [[ $val =~ ^[0-9]+$ ]]; then
                                        # check existancy
                                        exist=$(awk 'BEGIN{FS=":"; flag=0}{if ($'$res' == '$val') print $0 ; else print ""  }' $tName)
                                        if [[ $exist != "" ]]; then
                                            echo "primary key must be unique"
                                            break
                                        else
                                            # if not exist update it
                                            awk 'BEGIN{FS=":"}{if ($'$searchCol' == '$data') sub($'$res','$val')}{ print $0 }' $tName >>.tmpupdate
                                            cat .tmpupdate >$tName
                                            rm .tmpupdate
                                        fi
                                    else
                                        echo "Not valid value"
                                        break
                                    fi
                                # case of string data type
                                elif [[ ${datatypes[$temp2]} = "-s" ]]; then
                                    read -p "update Row set " val
                                    if [[ $val =~ [:] ]]; then
                                        echo "----Forbbiden character \":\" ----"
                                    else
                                        exist=$(awk 'BEGIN{FS=":"; flag=0}{if ($'$res'  ~  /'"$val"'/) print $0 ; else print ""  }' $tName)
                                        if [[ $exist != "" ]]; then
                                            echo "primary key must be unique"
                                            break
                                        else
                                            awk 'BEGIN{FS=":"}{if ($'$searchCol' ~  /'"$data"'/) sub($'$res','"\"$val\""')}{ print $0 }' $tName >>.tmpupdate
                                            cat .tmpupdate >$tName
                                            rm .tmpupdate
                                        fi
                                    fi
                                fi
                            #  case is not first column
                            else
                                temp2=$(($res - 1))
                                # check in types
                                if [[ ${datatypes[$temp2]} = "-i" ]]; then
                                    read -p "update Row set " val
                                    if [[ $val =~ ^[0-9]+$ ]]; then
                                        awk 'BEGIN{FS=":"}{if ($'$searchCol' == '$data') sub($'$res','$val')}{ print $0 }' $tName >>.tmpupdate
                                        cat .tmpupdate >$tName
                                        rm .tmpupdate
                                    else
                                        echo "Not valid value"
                                        break
                                    fi
                                elif [[ ${datatypes[$temp2]} = "-s" ]]; then
                                    read -p "update Row set " val
                                    if [[ $val =~ [:] ]]; then
                                        echo "----Forbbiden character \":\" ----"
                                    else
                                        awk 'BEGIN{FS=":"}{if ($'$searchCol' ~  /'"$data"'/) sub($'$res','"\"$val\""')}{ print $0 }' $tName >>.tmpupdate
                                        cat .tmpupdate >$tName
                                        rm .tmpupdate
                                    fi
                                fi
                            fi
                        else
                            echo "Record Not Found"
                            break
                        fi
                    done
                else
                    echo "Illegal value"
                fi
            elif [[ ${datatypes[$temp]} = "-s" ]]; then
                flag=0
                read -p "update Row where " data2
                menu $tName
                res=$?
                if [ $res -eq 0 ]; then
                    echo "------cancel updating process------"
                    idx=0
                    break
                fi
                # check if record exist or not
                result=$(awk 'BEGIN{FS=":"}{ if ($'$searchCol' ~  /'"$data2"'/) print $0; else print ""; }' $tName)
                if [[ $result != "" ]]; then
                    # case of first column it is primary key
                    if [[ $res -eq 1 ]]; then
                        # check type first case of integer
                        temp2=$(($res - 1))
                        echo "ss: ${datatypes[$temp2]} "
                        if [[ ${datatypes[$temp2]} = "-i" ]]; then
                            read -p "update Row set " val
                            if [[ $val =~ ^[0-9]+$ ]]; then
                                # check existancy
                                exist=$(awk 'BEGIN{FS=":"; flag=0}{if ($'$res' == '$val') print $0 ; else print ""  }' $tName)
                                if [[ $exist != "" ]]; then
                                    echo "primary key must be unique"
                                    break
                                else
                                    # if not exist update it
                                    awk 'BEGIN{FS=":"}{if ($'$searchCol' == '$data') sub($'$res','$val')}{ print $0 }' $tName >>.tmpupdate
                                    cat .tmpupdate >$tName
                                    rm .tmpupdate
                                fi
                            else
                                echo "Not valid value"
                                break
                            fi
                            # case of string data type
                        elif [[ ${datatypes[$temp2]} = "-s" ]]; then
                            read -p "update Row set " val
                            if [[ $val =~ [:] ]]; then
                                echo "----Forbbiden character \":\" ----"
                                break
                            else
                                exist=$(awk 'BEGIN{FS=":"; flag=0}{if ($'$res'  ~  /'"$val"'/) print $0 ; else print ""  }' $tName)
                                if [[ $exist != "" ]]; then
                                    echo "primary key must be unique"
                                    break
                                else
                                    awk 'BEGIN{FS=":"}{if ($'$searchCol' ~  /'"$data"'/) sub($'$res','"\"$val\""')}{ print $0 }' $tName >>.tmpupdate
                                    cat .tmpupdate >$tName
                                    rm .tmpupdate
                                fi
                            fi
                        fi
                        #  case is not first column
                    else
                        temp2=$(($res - 1))
                        # check in types
                        if [[ ${datatypes[$temp2]} = "-i" ]]; then
                            read -p "update Row set " val
                            if [[ $val =~ ^[0-9]+$ ]]; then
                                awk 'BEGIN{FS=":"}{if ($'$searchCol' == '$data') sub($'$res','$val')}{ print $0 }' $tName >>.tmpupdate
                                cat .tmpupdate >$tName
                                rm .tmpupdate
                            else
                                echo "Not valid value"
                                break
                            fi
                        elif [[ ${datatypes[$temp2]} = "-s" ]]; then
                            read -p "update Row set " val
                            if [[ $val =~ [:] ]]; then
                                echo "----Forbbiden character \":\" ----"
                                break
                            else
                                awk 'BEGIN{FS=":"}{if ($'$searchCol' ~  /'"$data"'/) sub($'$res','"\"$val\""')}{ print $0 }' $tName >>.tmpupdate
                                cat .tmpupdate >$tName
                                rm .tmpupdate
                            fi
                        fi
                    fi
                else
                    echo "Record Not Found"
                    break
                fi
            fi
        fi
        idx=0
    done
}
function updateTable {
    read -p "Enter Table Name:  " Tname
    if [[ $Tname =~ ^[a-zA-Z]{1}[_0-9a-zA-Z]{,31}$ ]]; then
        if [[ -f $Tname ]]; then
            while [ true ]; do
                echo "1) Update Entire column"
                echo "2) Update Specific Rows" #delete by any column
                echo "3) Go Back"
                curr=$(basename $(pwd))
                read -p "DB/$curr/${Tname}>> " option
                case $option in
                1) updateEntireColumn $Tname ;;
                2) updateSpecific $Tname ;;
                3) ./../../menuTA.sh ;;
                *) echo "not supported" ;;
                esac
            done
        else
            echo "----No such table named $Tname -----"
        fi
    fi
}
updateTable