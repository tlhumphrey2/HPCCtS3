#!/bin/bash -e

srcip=$(hostname|sed -e "s/ip-//" -e "s/-/./g")
echo "srcip=$srcip"
dz=/var/lib/HPCCSystems/mydropzone

dfu=/opt/HPCCSystems/bin/dfuplus

for file in `ls -1 $dz/*`
do
  basefile=$(echo "$file"|sed -e "s/^.*\///")
  echo "sudo $dfu action=spray srcip=$srcip server=$srcip srcfile=$file dstcluster=mythor format=csv dstname=thumphrey::$basefile overwrite=1"
  sudo $dfu action=spray srcip=$srcip server=$srcip srcfile=$file dstcluster=mythor format=csv dstname=thumphrey::$basefile overwrite=1
done
