#!/bin/bash

if test -z "$MONGO_PASSWORD"; then
    echo "MONGO_PASSWORD not defined"
    exit 7
fi

if test -z "$MONGO_DB"; then
    echo "MONGO_DB not defined"
    exit 8
fi

adminUserPass="-u admin -p $MONGO_PASSWORD"

appUser="${MONGO_DB}App"
appUserPass="-u $appUser -p $MONGO_PASSWORD"
crossbowDb="$MONGO_DB"

(echo "setup mongodb bootstrap users"

create_admin_user="if (!db.getUser('admin')) { db.createUser({ user: 'admin', pwd: '$MONGO_PASSWORD', roles: [ {role:'userAdminAnyDatabase',db:'admin'}, {role:'root', db:'admin'} ] } ) }"
until mongo admin --eval "$create_admin_user" || mongo admin $adminUserPass --eval "$create_admin_user"; do sleep 5; done

create_user="if (!db.getUser('$appUser')) { db.createUser({ user: '$appUser', pwd: '$MONGO_PASSWORD', roles: [ {role:'readWrite', db:'$crossbowDb'} ]}) }"
until mongo users --eval "$create_user" || mongo users $appUserPass --eval "$create_user"; do sleep 5; done

killall mongod
sleep 1
killall -9 mongod
) &


echo "starting mongodb without security"
chown -R mongodb "/data/${MONGO_DB}/mongo"
gosu mongodb mongod "$@"

echo "restarting mongodb with authentication enabled"
sleep 5
exec gosu mongodb mongod --bind_ip_all --auth "$@"