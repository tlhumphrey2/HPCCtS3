#!/usr/bin/perl

# Ran ONLY on master (esp)

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '.';

require "$thisDir/common.pl";

openLog($cp2s3_logname);

printLog($cp2s3_logname,"Entering cpLZAndMetadataFilesToS3.pl\n");

$s3bucket = "s3://tlh_hpcc_esp_backup";
printLog($cp2s3_logname,"In cpLZAndMetadataFilesToS3.pl. juju_unit_number=\"$juju_unit_number\", s3bucket=\"$s3bucket\"\n");

($master_pip, @slave_pip)=thor_nodes_ips();
printLog($cp2s3_logname,"In cpAllFilePartsToS3.pl. master_pip=\"$master_pip\"\n");

@FilesOnThor = FilesOnThor($master_pip);
if ( scalar(@FilesOnThor)==0 ){
   printLog($cp2s3_logname,"In cpAllFilePartsToS3. There are no files on the thor.\nSo EXITing.");
}

# check for files on dropzone
system("ls -l $DropzoneFolder > /tmp/dropzone-files.txt");
$FilesOnDropzone=1;
if ( `cat /tmp/dropzone-files.txt` =~ /\btotal\s+0\b/is ){
   $FilesOnDropzone=0;
}

$cfg=get_s3cmd_config($juju_unit_number);

# If s3 bucket, tlh_hpcc_backup, does not exist, create it.
system("sudo s3cmd $cfg ls $s3bucket 2> /tmp/bucket_exists.txt");
if ( `cat /tmp/bucket_exists.txt` =~ /not exist/i ){
   printLog($cp2s3_logname,"sudo s3cmd $cfg mb $s3bucket\n");
   system("sudo s3cmd $cfg mb $s3bucket");
}
else{
   printLog($cp2s3_logname,"In cpLZAndMetadataFilesToS3.pl. WARNING. s3 bucket, $s3bucket, already EXISTS\nSo, we do not need to create it.\n");
}

#-------------------------------------------------------------------------------
# Put metadata for all files on mythor out to $s3bucket
#-------------------------------------------------------------------------------

if (scalar(@FilesOnThor) > 0 ){
# Make a folder for metadata files
  mkdir $MetadataFolder if ! -e $MetadataFolder;
  
  #For each of the above files, get and put its metadata in ~/metadata
  printLog($cp2s3_logname,"Get metadata file for: ".join("\nGet metadata file for: ",@FilesOnThor)."\n");
  foreach (@FilesOnThor){
     s/^\.:://;
     printLog($cp2s3_logname,"$dfuplus server=$master_pip action=savexml srcname=$_ dstxml=$MetadataFolder/$_.xml\n");
     system("$dfuplus server=$master_pip action=savexml srcname=$_ dstxml=$MetadataFolder/$_.xml");
  }
  printLog($cp2s3_logname,"Completed getting metadata for files.\n");

  #Copy all metadata to $s3bucket/metadata
  printLog($cp2s3_logname,"DEBUG: sudo s3cmd $cfg put --recursive $MetadataFolder/* $s3bucket/metadata/\n");
  system("sudo s3cmd $cfg put --recursive $MetadataFolder/* $s3bucket/metadata/ > /dev/null 2> /dev/null");
}

if ( $FilesOnDropzone ){
  #Copy all files on dropzone into S3.
  printLog($cp2s3_logname,"DEBUG: sudo s3cmd $cfg put --recursive $DropzoneFolder/* $s3bucket/lz/\n");
  system("sudo s3cmd $cfg put --recursive $DropzoneFolder/* $s3bucket/lz/ > /dev/null 2> /dev/null");
}

system("echo \"done\" > $cp2s3_DoneAlertFile");
printLog($cp2s3_logname,"Done copying files to S3\n");
