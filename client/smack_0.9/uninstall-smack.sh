#! /bin/bash

#echo to uninstall zeppelin
dcos package uninstall zeppelin

echo 
echo to uninstall tweeter
curl -X DELETE  --header 'Content-Type: */*' --header 'Accept: application/json' 'http://localhost:10004/v1/appsets/tweeter'

echo
echo to uninstall spark
dcos package uninstall spark
./zk -zk master.mesos:2181 -path /spark_mesos_dispatcher

echo
echo to uninstall cassandra
dcos package uninstall cassandra
./zk -zk master.mesos:2181 -path /cassandra-mesos
# remove empty cassandra group on marathon
dcos marathon group remove --force cassandra
./janitor.py -r cassandra-role -p cassandra-principal -z cassandra-mesos

echo
echo to uninstall kafka
dcos package uninstall kafka
./zk -zk master.mesos:2181 -path /kafka-mesos
./zk -zk master.mesos:2181 -path /brokers
./janitor.py -r kafka-role -p kafka-principal -z brokers

echo
echo to uninstall grafana\hdfs\influxdb
curl -X DELETE  --header 'Content-Type: */*' --header 'Accept: application/json' 'http://localhost:10004/v1/appsets/iot-dashboard'
