#!/bin/bash -e

if [ "$1" = "" ]
then
   echo "Must pass in ESP's juju unit-id. EXITING."
   exit 1;
fi

esp=$1
dz=/var/lib/HPCCSystems/mydropzone
echo "esp=\"$esp\", dz=\"$dz\""

echo "juju scp $share/myfile_head*.csv $esp:$dz"
juju scp $share/myfile_head*.csv $esp:$dz

echo "juju scp $share/dfu_spray.sh $esp:/home/ubuntu"
juju scp $share/dfu_spray.sh $esp:/home/ubuntu

echo "juju ssh $esp /home/ubuntu/dfu_spray.sh"
juju ssh $esp /home/ubuntu/dfu_spray.sh

