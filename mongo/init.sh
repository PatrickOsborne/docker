#!/bin/bash

if test -z "$MONGO_PASSWORD"; then
    echo "(MONGO_PASSWORD) is not defined"
    exit 7
fi

if test -z "$MONGO_DB"; then
    echo "(MONGO_DB) is not defined"
    exit 8
fi

# start mongo with a temporary port first time, before configuring security, so apps polling and waiting for server to be ready on
# standard port wont be confused.
tempPort=30729

adminUserPass="-u admin -p $MONGO_ADMIN_PASSWORD"

appUser="${MONGO_DB}App"
appUserPass="-u $appUser -p $MONGO_PASSWORD"
mongoDb="$MONGO_DB"
configFilePath=${MONGO_CONF_PATH}

echo "db ($mongoDb)"
echo "config file path ($configFilePath)"

(echo "setup mongodb bootstrap users"

create_admin_user="if (!db.getUser('admin')) { db.createUser({ user: 'admin', pwd: '$MONGO_PASSWORD', roles: [ {role:'userAdminAnyDatabase',db:'admin'}, {role:'root', db:'admin'} ] } ) }"
until mongo --port ${tempPort} admin --eval "$create_admin_user" || mongo --port ${tempPort} admin $adminUserPass --eval "$create_admin_user"; do
sleep 5; done

create_user="if (!db.getUser('$appUser')) { db.createUser({ user: '$appUser', pwd: '$MONGO_PASSWORD', roles: [ {role:'readWrite', db:'$mongoDb'} ]}) }"
until mongo --port ${tempPort} users --eval "$create_user" || mongo --port ${tempPort} users $appUserPass --eval "$create_user"; do sleep 5; done

killall mongod
sleep 1
killall -9 mongod
) &


echo "starting mongodb without security"
chown -R mongodb "/data/${MONGO_DB}/mongo"
gosu mongodb mongod --port ${tempPort} "$@"

echo "restarting mongodb with authentication enabled"
sleep 2
exec gosu mongodb mongod --bind_ip_all --auth --config ${configFilePath} "$@"