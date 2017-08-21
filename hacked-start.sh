#!/bin/sh

export EMQ_HOST=$(ip route get $(getent hosts ${EMQ_CLUSTER__DNS__NAME} | awk '{print $1}') | awk '{print $NF}')
echo Using $EMQ_HOST
sed -i 's/## cluster.dns/cluster.dns/g' /opt/emqttd/etc/emq.conf
/opt/emqttd/start.sh
