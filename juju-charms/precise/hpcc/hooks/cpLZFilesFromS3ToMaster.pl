#!/usr/bin/perl


$thisDir = ( $0 =~ /^(.+)\// )? $1 : '.';

require "$thisDir/common.pl";

openLog($cpfs3_logname);

$s3bucket = "s3://tlh_hpcc_esp_backup";
printLog($cpfs3_logname,"In cpLZFilesFromS3ToMaster.pl. juju_unit_number=\"$juju_unit_number\", s3bucket=\"$s3bucket\"\n");

$cfg=get_s3cmd_config($juju_unit_number);

system("sudo s3cmd $cfg ls $s3bucket 2> /tmp/bucket_exists.txt");
if ( `cat /tmp/bucket_exists.txt` =~ /not exist/i ){
   printLog($cpfs3_logname,"In cpLZFilesFromS3ToMaster.pl. The s3 bucket, tlh_hpcc_backup, DOES NOT EXISTS.\nEXITing.\n");
   exit 0;
}

#Copy all S3 files of dropzone into mydropzone.
system("mkdir $DropzoneFolder") if ! -e $DropzoneFolder;
system("cd $DropzoneFolder;sudo s3cmd $cfg get $s3bucket/lz/* > /dev/null 2> /dev/null");

printLog($cpfs3_logname,"In cpLZFilesFromS3ToMaster.pl. Completed copying from S3 all LZ files.\n");
