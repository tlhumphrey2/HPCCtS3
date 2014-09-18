#!/usr/bin/perl

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '';

require "$thisDir/common.pl";

openLog($cpfs3_logname);

$s3bucket = "s3://tlh_hpcc_esp_backup";
printLog($cpfs3_logname,"In cpMetadataFilesFromS3ToNode.pl. juju_unit_number=\"$juju_unit_number\", s3bucket=\"$s3bucket\"\n");

$cfg=get_s3cmd_config($juju_unit_number);
printLog($cpfs3_logname,"In cpMetadataFilesFromS3ToNode.pl. cfg=\"$cfg\"\n");

system("sudo s3cmd $cfg ls $s3bucket 2> /tmp/bucket_exists.txt");
if ( `cat /tmp/bucket_exists.txt` =~ /not exist/i ){
   printLog($cpfs3_logname,"In cpMetadataFilesFromS3ToNode.pl. The s3 bucket, tlh_hpcc_backup, DOES NOT EXISTS.\nEXITing.\n");
   exit 0;
}

#Copy metadata files from S3 to $MetadataFolder of $ThisNodePip
system("mkdir $MetadataFolder") if ! -e "$MetadataFolder";
system("cd $MetadataFolder;sudo s3cmd $cfg get $s3bucket/metadata/* 2> /dev/null > /dev/null");

($master_pip, @slave_pip)=thor_nodes_ips();

#-------------------------------------------------------------------------------------------------------------
# Change private ips in each file's metadata to the private ips of the current slaves.
#-------------------------------------------------------------------------------------------------------------

if ( opendir(DIR,$MetadataFolder) )
{
      @dir_entry = readdir(DIR);
      closedir(DIR);
      @metadatafile=grep( /\.xml$/,@dir_entry);
      my $NumberMetadataFiles=scalar(@metadatafile);
      printLog($cpfs3_logname,"DEBUG: In cpMetadataFilesFromS3ToNode.pl. There are $NumberMetadataFiles metadata files.\n");
}
else
{
     printLog($cpfs3_logname,"In cpMetadataFilesFromS3ToNode.pl. ERROR: In $0. Couldn't open directory for \"$MetadataFolder\"\n");
     exit 1;
}

undef $/;
$comma_separated_slave_ips=join(",",@slave_pip);
foreach my $mfile (@metadatafile){
   printLog($cpfs3_logname,"DEBUG: In cpMetadataFilesFromS3ToNode.pl. Open metadata file: $mfile.\n");
   open(IN,"$MetadataFolder/$mfile") || die "Can't open for input metadata file: \"$mfile\"";
   local $_=<IN>;
   close(IN);

   printLog($cpfs3_logname,"DEBUG: In cpMetadataFilesFromS3ToNode.pl. In $mfile, change <Group> private ips.\n");
   s/<Group>.+?<\/Group>/<Group>$comma_separated_slave_ips<\/Group>/s;
   open(OUT,">$MetadataFolder/t") || die "Can't open for output metadata file: \"t\"\n";
   print OUT $_;
   close(OUT);
   printLog($cpfs3_logname,"DEBUG: In cpMetadataFilesFromS3ToNode.pl. system(\"mv -f $MetadataFolder/t $MetadataFolder/$mfile\")\n");
   system("mv -f $MetadataFolder/t $MetadataFolder/$mfile");
}

printLog($cpfs3_logname,"In cpMetadataFilesFromS3ToNode.pl. Completed copying from S3 metadata files to node and changing slave ips of them.\n");
