#!/bin/bash
function get_pip_unit()
{
hpcc_service=$1
esp_private=$2

z=$(juju status|egrep "tlh-hpcc\/"|wc -l)
max_unit=`expr $z - 1`

for v in {0..$max_unit}
do
echo "DEBUG: In get_pip_unit for loop. v=$v, max_unit=$max_unit"
  x=$(juju ssh $hpcc_service/$v "uname -a" 2> /dev/null \
     | sed -e "s/^.*ip\-\([0-9][0-9]*\-[0-9][0-9]*\-[0-9][0-9]*\-[0-9][0-9]*\).*$/\1/" -e "s/\-/./g")
  if [ "$x" = "$esp_private_ip" ]
   then
     echo "$hpcc_service/$v is ESP"
     exit 0
   fi
done
}
