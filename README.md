# Webtrees Docker

The web's leading on-line collaborative genealogy application.

## Environment variables

* **SERVER_NAME** : URL from which Webtrees will be available (e.g. 192.168.1.101:8080 or http://webtrees.example.com)
* **WEBTREES_DB_HOST** : Database host, either different host or the name of the docker-compose service containing the database instance
* **WEBTREES_DB_PORT** : Port on which the database is accessible
* **WEBTREES_DB_USER** : Username for accessing the database
* **WEBTREES_DB_PASS** : Password for the database user
* **WEBTREES_DB_NAME** : Name of the database to be created
* **WEBTREES_TBL_PFX** : Optional, prefix given to all Webtrees-created database tables

## Sample docker-compose file

The following docker-compose will start two containers: a mariadb container for the database and the webtrees container running Webtrees. The volumes declared ensure that the database and Webtrees content are preserved across container restarts. Specifically, the volumes declared as storing their data in the same directory as the docker-compose.yml file. Finally, the Webtrees instance is being made available on port 8080 of the machine indicated (in this example, the machine hosting this Webtrees install is only available via the 192.168.1.101 IP address).

The SERVER_NAME environment variable is used to set the server name within the running instance. This is necessary due to the way Webtrees performs redirections between pages. If the server name were blank, redirects would fail and Webtrees would be unusable. By explicitly setting the server name, all Webtrees page redirects begin with the SERVER_NAME indicated, followed by the desired page.

```
version: '3'
services:
  db:
    image: mariadb:10
    container_name: webtrees-db
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root_pass_here
      - MYSQL_DATABASE=my_database_here
      - MYSQL_USER=my_user_here
      - MYSQL_PASSWORD=my_pass_here
  site:
    image: webtrees-docker:latest
    container_name: webtrees-site
    volumes:
      - ./webtrees/data:/var/www/html/data
    environment:
      - SERVER_NAME=192.168.1.101:8080
      - WEBTREES_DB_HOST=db
      - WEBTREES_DB_PORT=3306
      - WEBTREES_DB_USER=my_user_here
      - WEBTREES_DB_PASS=my_pass_here
      - WEBTREES_DB_NAME=my_database_here
      - WEBTREES_TBL_PFX=wt_
    ports:
      - "8080:80"
```

## Finishing install

Once the containers are running, simply visit the IP:PORT or URL of the install and complete the installation steps.

The "Server name" should be *db* and the "Port number" should be *3306*
