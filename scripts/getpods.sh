#!/bin/bash

if [ x"${AWS_ACCESS_KEY_ID}" == "x" ]; then 
     echo "Value is not assigned to a AWS_ACCESS_KEY_ID"
  else
     echo "Value is assigned to a AWS_ACCESS_KEY_ID"
  fi

if [ x"${AWS_SECRET_ACCESS_KEY}" == "x" ]; then 
     echo "Value is not assigned to a AWS_SECRET_ACCESS_KEY"
  else
     echo "Value is assigned to a AWS_SECRET_ACCESS_KEY"
  fi  

if [ x"${AWS_DEFAULT_REGION}" == "x" ]; then 
     echo "Value is not assigned to a AWS_DEFAULT_REGION"
  else
     echo "Value is assigned to a AWS_DEFAULT_REGION"
  fi 

typeofvar () {

    local type_signature=$(declare -p "$1" 2>/dev/null)

    if [[ "$type_signature" =~ "declare --" ]]; then
        printf "string"
    elif [[ "$type_signature" =~ "declare -a" ]]; then
        printf "array"
    elif [[ "$type_signature" =~ "declare -A" ]]; then
        printf "map"
    else
        printf "none"
    fi

}

#kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |\
#tr -s '[[:space:]]' '\n' |\
#sort |\
#uniq

pods=$(kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |\
tr -s '[[:space:]]' '\n' |\
sort |\
uniq)

#typeofvar pods

IFS=$'\n' read -rd '' -a my_array <<< "$pods"

#echo $my_array
#typeofvar my_array

echo "pod, version" > pods.csv

for i in "${my_array[@]}"
do
    pod_name_tmp=$(cut -d : -f 1 <<< $i)
    pod_name=$(echo "$pod_name_tmp" | rev | cut -d / -f 1 | rev)
    version=$(cut -d : -f 2 <<< $i)
	echo "$pod_name","$version" >> pods.csv
done

cat pods.csv

aws s3 cp pods.csv s3://demome