#!/bin/bash -e
# Example Usage: cpEnv.sh /home/ubuntu/environment_8slaves.xml tlh-hpcc/0 tlh-hpcc/1 tlh-hpcc/2
# Example Usage: cpEnv.sh /home/ubuntu/environment_4slaves.xml tlh-hpcc/0 tlh-hpcc/1 tlh-hpcc/2

#--------------------------------------------------------------------------------------
# This script copies the environment file (1st argument) to /etc/HPCCSystems on all nodes of the THOR
#--------------------------------------------------------------------------------------

# There are 2 initial arguments followed by juju-ids for each non-supporting instance (i.e. instances containing slave nodes)
newly_created_environment_xml=$1
esp=$2

out_environment_file=/etc/HPCCSystems/environment.xml

echo "copying \"$newly_created_environment_xml\" to  \"$out_environment_file\""
echo "juju ssh $esp \"sudo -u hpcc cp $newly_created_environment_xml $out_environment_file\""
juju ssh $esp "sudo -u hpcc cp -f $newly_created_environment_xml $out_environment_file"

# copy environment.xml file to local ubuntu in home directory
echo "juju scp $esp:/etc/HPCCSystems/environment.xml ."
juju scp $esp:/etc/HPCCSystems/environment.xml .

for instance in ${@:3};do
   echo "In loop. instance=\"$instance\""
   # copy environment.xml to node $instance:/home/ubuntu then to /etc/HPCCSystems
   echo juju scp /home/user/environment.xml $instance:/home/ubuntu
   juju scp /home/user/environment.xml $instance:/home/ubuntu
   echo "juju ssh $instance sudo cp -f /home/ubuntu/environment.xml /etc/HPCCSystems"
   juju ssh $instance 'sudo cp -f /home/ubuntu/environment.xml /etc/HPCCSystems'
done

echo "juju ssh $esp sudo service hpcc-init start"
juju ssh $esp 'sudo service hpcc-init start'
