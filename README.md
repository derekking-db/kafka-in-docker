# Kafka-in-Docker

Docker compose file to bring up a Kafka and Zookeeper install for testing purposes. 

The config is currently set for readers of the Databricks blog 'Ingesting Windows Event Logs into Databricks' <<link>>.

## Pre-Requisites

Best installed on a fresh AWS instance since it uses the metadata service to configure advertised.listener. If you want to run this somewhere else, change the docker-compose.yml file.

* Create an EC2 Instance, with a MINIMUM of 16GB Ram. Anything less will fail the install.
* If you plan to send data to the Kafka server from outside of the cloud provider, create an inbound security group rule for TCP 9094.

I have tested this on t2.xlarge Ubuntu 20.04 which works for my purposes. 

## Installation

The install.sh script will download and install docker, docker-compose and everything else you need to get up and running. You'll need to download the repo and execute the install script however.

```
git clone https://github.com/DerekKing001/kafka-in-docker.git
cd kafka-in-docker
sudo ./install.sh
```

If you want to have the instance install and run kafka instantly run the following in from the ec2 userdata section.

```
git clone https://github.com/DerekKing001/kafka-in-docker.git 1>>/var/log/install.log 2>&1
cd kafka-in-docker 1>>/var/log/install.log 2>&1
sudo ./install.sh 1>>/var/log/install.log 2>&1
```

### Checking and Testing the Installation
Once installed, you'll probably want to check a few things out. Logon to the host via ssh.

**Example EC2 based on ubuntu**

```ssh -i <pem_file> ubuntu@<hostname>```

## Is my docker env running?

```sudo docker ps```

## Check the logs

```sudo docker logs --follow docker-kafka-1```

## Run a shell on the Kafka Server
```sudo docker exec -it docker-kafka-1 bash```

## Testing the topics created OK?

After running a shell on the kafka container

```
cd /opt/kafka/bin
./kafka-topics.sh --bootstrap-server <hostname> --list
```
By default, the compose file is setup to create the 'winlogbeat' topic only. 

## Produce a test message

from /opt/kafka/bin

``` ./kafka-console-producer.sh --bootstrap-server <hostname>:9094 --topic winlogbeat```

input is received until CTRL-d

## Consume the test message

from /opt/kafka/bin

```./kafka-console-consumer.sh --bootstrap-server <hostname>:9094 --topic winlogbeat --from-beginning```















