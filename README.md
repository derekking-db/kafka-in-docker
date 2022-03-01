# Kafka-in-Docker

Docker compose file to bring up a Kafka and Zookeeper install for testing purposes. 

The config is currently set for readers of the Databricks blog 'Ingesting Windows Event Logs into Databricks' <<link>>.

## Pre-Requisites

Best installed on a fresh AWS instance since it uses the metadata service to configure advertised.listener. If you want to run this somewhere else, change the docker-compose.yml file.

* Create an EC2 Instance, with a MIMIMUM of 16GB Ram. Anything less will fail the install.
* If you plan to send data to the Kafka server from outside of the cloud provider, create an inbound security group rule for TCP 9094.

## Installation

The install.sh script will download and install docker, docker-compose and everything else you need to get up and running. You'll need to download the repo and execute the install script however.

```
git clone https://github.com/DerekKing001/kafka-in-docker.git
cd kafka-in-docker
sudo ./install.sh
```

### Checking and Testing the Installation

## Is my docker env running?

```sudo docker ps```

## Run a shell on the Kafka Server
```sudo docker exec -it ```

## Were the topics created OK?












