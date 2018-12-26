# Mongodb


## Configuration

During initialization users and databases are created


### Environment Variables

 * MONGO_DB: name of database to create
 * MONGO_PASSWORD: used as the password for all created users

 
### Users

Users are created with password provided as env variable $MONGO_PASSWORD.

* admin user: admin
    - admin user has been provided root privileges during creation in init.sh (look for: {role:'root', db:'admin'})
      this allows the Mongo Compass UI to access the db instance with the admin user
* normal user: `${MONGO_DB}App`


### Databases

* `${MONGO_DB}`


### Data Storage

Data is stored in `/data/${MONGO_DB}/mongo`


## Build

execute: `mvn clean install -Pdocker`
execute to push to docker hub: `mvn clean deploy -Pdocker`


## Run

### via Docker Compose

use: run-docker.sh to start server in a docker container


## Tools

### Compass

Compass is UI for Mongodb.  See the [download page](https://www.mongodb.com/download-center?filter=enterprise#compass).