#!/usr/bin/perl

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '.';

require "$thisDir/common.pl";

printLog($cpfs3_logname,"Entering cpAllFilePartsFromS3ToThisSlaveNode.pl\n");

($master_pip, @slave_pip)=thor_nodes_ips();
printLog($cpfs3_logname,"In cpAllFilePartsFromS3ToThisSlaveNode. slave_pip\[$slave_number\]=\"$slave_pip[$i]\n");
printLog($cp2s3_logname,"In cpAllFilePartsFromS3ToThisSlaveNode.pl. master_pip=\"$master_pip\"\n");

$ThisSlaveNodesPip = get_this_nodes_private_ip();

$thor_slave_number = get_thor_slave_number($ThisSlaveNodesPip,\@slave_pip);

$s3bucket = "s3://tlh_hpcc_${thor_slave_number}_backup";
printLog($cpfs3_logname,"In cpAllFilePartsFromS3ToThisSlaveNode.pl. s3bucket=\"$s3bucket\"\n");

$cfg=get_s3cmd_config($juju_unit_number);

# Make sure the s3 bucket exists. If it doesn't then print a WARNING and exit.
system("sudo s3cmd $cfg ls $s3bucket 2> /tmp/bucket_exists.txt");
if ( `cat /tmp/bucket_exists.txt` =~ /not exist/i ){
   printLog($cpfs3_logname,"In cpAllFilePartsFromS3ToThisSlaveNode.pl. WARNING. The s3 bucket, tlh_hpcc_backup, DOES NOT EXISTS. EXITing.\n");
   system("echo \"done\" > $cpfs3_DoneAlertFile");
   exit 0;
}

# Copy all file part on $s3bucket/thor/$thor_slave_number/* into $FilePartsFolder
cpAllFilePartsOnS3($FilePartsFolder,"$s3bucket/thor");

# Let everyone know this node has completed copying file parts from S3 to node.
system("echo \"done\" > $cpfs3_DoneAlertFile");
