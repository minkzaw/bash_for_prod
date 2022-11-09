#!/bin/bash
echo """This script is meant for the recovery process of 2FA in containerized nextcloud application!"""
read -p "Which user would you like to query? " user_query
read -p "Would you like to continue the script? (y/n)" result
if [ "${result^^}" == "Y" ] && [ ${#user_query} -gt 2 ]; then
    read -p "Please enter the DB container name specifically: " db_container_name
    query_db=$(sudo docker exec -it $db_container_name /bin/bash -c "mysql -u root -proot nextcloud -e 'select * from oc_users'| grep -i $user_query | awk -F ' ' '{print $1}'")
    user_id=$(echo $query_db | awk -F ' ' '{print $1}')
    read -p "Please enter the APP container name specifically: " app_container_name
    list_provider=$(sudo docker exec --user www-data --workdir /var/www/html -it $app_container_name /bin/bash -c "php occ twofactorauth:state $user_id")
    echo "$list_provider" | head -1

elif [ "${result^^}" == "N" ]; then
    echo "Good Bye!"
fi
    exit 1