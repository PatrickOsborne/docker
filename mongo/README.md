# Mongodb


## Configuration

During initialization users and databases are created


### Environment Variables

 * MONGO_DB: name of database to create
 * MONGO_ADMIN_PASSWORD: used as the password for mongo `admin` user
 * MONGO_PASSWORD: used as the password for specified db user
 * MONGO_CONF_PATH: path to mongo config file

 
### Users

Users are created with password provided as env variable $MONGO_PASSWORD.

* admin user: admin
    - admin user has been provided root privileges during creation in init.sh (look for: {role:'root', db:'admin'})
      this allows the Mongo Compass UI to access the db instance with the admin user
* normal user: `${MONGO_DB}App`


### Databases

* `${MONGO_DB}`


### Data Storage

In the container the data is stored under `/data/db`.

The mongo-persisted entry in docker-compose writes the data to `/data/mongo/${MONGO_DB}`


## Build

execute: `mvn clean install -Pdocker`
execute to push to docker hub: `mvn clean deploy -Pdocker`


## Run

### via Docker Compose

use: run-docker.sh to start server in a docker container


## Tools

### Compass

Compass is UI for Mongodb.  See the [download page](https://www.mongodb.com/download-center?filter=enterprise#compass).