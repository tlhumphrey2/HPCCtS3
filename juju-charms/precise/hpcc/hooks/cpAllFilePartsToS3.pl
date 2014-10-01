#!/usr/bin/perl

#NOTE: This code is ran on master (esp) ONLY.

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '.';

require "$thisDir/common.pl";

openLog($cp2s3_logname);

printLog($cp2s3_logname,"Entering cpAllFilePartsToS3.pl\n");

($master_pip, @slave_pip)=thor_nodes_ips();
printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. master_pip=\"$master_pip\"\n");

$ThisSlaveNodesPip = get_this_nodes_private_ip();
printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. ThisSlaveNodesPip=\"$ThisSlaveNodesPip\"\n");

$thor_slave_number = get_thor_slave_number($ThisSlaveNodesPip,\@slave_pip);

$s3bucket = "s3://tlh_hpcc_${thor_slave_number}_backup";
printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. s3bucket=\"$s3bucket\"\n");

@FilesOnThor = FilesOnThor($master_pip);
if ( scalar(@FilesOnThor)==0 ){
   printLog($cp2s3_logname,"In cpAllFilePartsToS3. There are no files on the thor.\nSo EXITing.");
   system("echo \"done\" > $cp2s3_DoneAlertFile");
   exit 0;
}

$cfg=get_s3cmd_config($juju_unit_number);

# If s3 bucket, tlh_hpcc_backup, does not exist, create it.
system("sudo s3cmd $cfg ls $s3bucket 2> /tmp/bucket_exists.txt");
if ( `cat /tmp/bucket_exists.txt` =~ /not exist/i ){
   system("sudo s3cmd $cfg mb $s3bucket");
}
else{
   printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. s3 bucket, $s3bucket, already EXISTS\nSo, we do not need to create it.\n");
}

if ( scalar(@FilesOnThor)>0 ){
     printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. sudo s3cmd $cfg put --recursive $FilePartsFolder/* $s3bucket/thor/ > /dev/null 2> /dev/null\n");
     system("sudo s3cmd $cfg put --recursive $FilePartsFolder/* $s3bucket/thor/ > /dev/null 2> /dev/null");
}
else{
     printLog($cp2s3_logname,"NO File parts to copy to S3.\n");
}

system("echo \"done\" > $cp2s3_DoneAlertFile");
printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. Done copying file parts to S3.\n");
