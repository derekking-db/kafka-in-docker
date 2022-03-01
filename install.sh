#!/bin/bash
# Simple script to execute the install of docker to the host, and then instantiate kafka and zookeeper containers.

LOGFILE="/var/log/install.log"
# Running the Docker and Docker-compose install script.
if [ ! -e ./docker_install.sh ]
then
    echo "ERROR: docker_install.sh cannot be found - please check" >>$LOGFILE
    exit 1
else
    ./docker_install.sh
    ERROR=$?
    if [ $ERROR -ne 0 ]
    then
        echo "cannot install docker components: (Error: $ERROR)"
        echo "check $LOGFILE for more information"
        exit 1
    fi

fi

# Executing docker-compose
echo "Executing docker compose: ./docker/docker-compose.yml"
docker-compose -f docker/docker-compose.yml up -d
ERROR=$?
if [ $ERROR -ne 0 ]
    then
    echo "cannot instantiate containers: (Error: $ERROR)"
    exit 1
fi

exit 0

