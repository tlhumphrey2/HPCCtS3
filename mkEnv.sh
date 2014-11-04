#!/bin/bash -e
# Usage: mkEnv.sh tlh-hpcc/4 /var/lib/HPCCSystems/charm/ip_file.txt /home/ubuntu/environment_8slaves.xml 1 2 0 4
# Usage: mkEnv.sh tlh-hpcc/0 /var/lib/HPCCSystems/charm/ip_file.txt /home/ubuntu/environment_8slaves.xml 1 2 0 4
# Usage: mkEnv.sh tlh-hpcc/1 /var/lib/HPCCSystems/charm/ip_file.txt /home/ubuntu/environment_4slaves.xml 1 2 0 2

# There are ALWAYS 7 input arguments
esp=$1;
ipfile=$2;
out_env=$3;
supportnodes=$4;
instances=$5;
roxienodes=$6;
slavesPerNode=$7;

echo "juju ssh $esp 'sudo service hpcc-init stop'";
juju ssh $esp 'sudo service hpcc-init stop';
echo "juju ssh $esp 'sudo service dafilesrv stop'";
juju ssh $esp 'sudo service dafilesrv stop';

envgen=/opt/HPCCSystems/sbin/envgen;

echo "juju ssh $esp \"sudo $envgen -env $out_env -ipfile $ipfile -supportnodes $supportnodes -thornodes $instances -roxienodes $roxienodes -slavesPerNode $slavesPerNode -roxieondemand 1\"";
juju ssh $esp "sudo $envgen -env $out_env -ipfile $ipfile -supportnodes $supportnodes -thornodes $instances -roxienodes $roxienodes -slavesPerNode $slavesPerNode -roxieondemand 1";
