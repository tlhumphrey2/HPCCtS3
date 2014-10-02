#!/usr/bin/perl
$HomePath="/home/ubuntu";

# Get hpcc service name and juju unit number
my $service_re = '[a-zA-Z][\w\-]*';
$_=`ls -l /var/log/juju/*`;
$service = $1 if /unit-($service_re)-\d+.log/;
( $service_name = $service ) =~ s/\-/_/g;
$juju_unit_number = $1 if /unit-${service}-(\d+).log/;

#Log and Alert files
$cpfs3_logname = "$HomePath/${service_name}_cpFilesFromS3.log";
$cpfs3_DoneAlertFile = "$HomePath/done_cpFilesFromS3";
$cp2s3_logname = "$HomePath/${service_name}_cpFiles2S3.log";
$cp2s3_DoneAlertFile = "$HomePath/done_cpFiles2S3";
$AlertDoneRestoringLogicalFiles = "$HomePath/done_restoring_logical_files";

#HPCC System folders
$FilePartsFolder='/var/lib/HPCCSystems/hpcc-data/thor';
$DropzoneFolder='/var/lib/HPCCSystems/mydropzone';
$SlaveNodesFile='/var/lib/HPCCSystems/mythor/slaves';     # This file must be on master

#Metadata folder
$MetadataFolder='/home/ubuntu/metadata';

# HPCCSystems paths of interest and utilities.
$hsbin='/opt/HPCCSystems/sbin';
$configgen="$hsbin/configgen";
$hbin='/opt/HPCCSystems/bin';
$dfuplus="$hbin/dfuplus";
$daliadmin="$hbin/daliadmin";

#Template for hooks folder
$hooks_template="/var/lib/juju/agents/unit-<service>-<juju_unit_number>/charm/hooks";

#===================== Subroutines/Functions =======================================
#-----------------------------------------------------------------------------------
sub openLog{
my ( $logname )=@_;

     $logname = "-" if $logname eq '';
     if ( ! -e $logname ){
        open(LOG,">$logname") || die "Can't open for output \"$logname\"\n";
     }
     else{
        open(LOG,">>$logname") || die "Can't open for output \"$logname\"\n";
     }
}
#-----------------------------------------------------------------------------------
sub printLog{
my ( $logname, $text2print )=@_;
  print LOG $text2print;
}
#-----------------------------------------------------------------------------------
sub thor_nodes_ips{
  my $master_pip = `$configgen -env /etc/HPCCSystems/environment.xml -listall | grep mythor`;
  $master_pip = $1 if $master_pip =~ /(\b\d+(?:\.\d+){3}\b)/;
  my @slave_pip=split(/\n/,`$daliadmin $master_pip dfsgroup mythor`);
return ($master_pip, @slave_pip);
}
#-----------------------------------------------------------------------------------
# This can only be used on the master node
sub get_ordered_thor_slave_ips{
  my ($master_pip,@slave_pip) = thor_nodes_ips();
return @slave_pip;
}
#-----------------------------------------------------------------------------------
sub get_this_nodes_private_ip{
my ($logname)=@_;
  # Get the private ip address of this slave node 
  $_=`ifconfig`;
  s/^.*?eth0/eth0/s;
  s/\n\s*\n.*$//s;

  my $ThisNodesPip='99.99.99.99';
  if ( /inet addr:(\d+(?:\.\d+){3})\b/s ){
     $ThisNodesPip = $1;
     printLog($logname,"In get_this_nodes_private_ip.pl. ThisNodesPip=\"$ThisNodesPip\"\n");
  }
  else{
     printLog($logname,"In get_this_nodes_private_ip. Could not file ThisNodesPip in ifconfig's output. EXITing\n");
  }
return $ThisNodesPip;
}
#-----------------------------------------------------------------------------------
sub get_thor_slave_number{
my ($ThisSlaveNodesPip,$slave_pip_ref)=@_;
my @slave_pip = @$slave_pip_ref;

  # Find the private ip address of @slave_pip that matches this
  #  slave node's ip address. When found index, where index begins with 1, into @all_slave_nod_ips will
  #     be $ThisSlaveNodeId.
  my $thor_slave_number='';
  my $FoundThisSlaveNodeId=0;
  for( my $i=0; $i < scalar(@slave_pip); $i++){
     if ( $slave_pip[$i] eq $ThisSlaveNodesPip ){
        $thor_slave_number=$i+1;
        printLog($cpfs3_logname,"In get_thor_slave_number. thor_slave_number=\"$thor_slave_number\"\n");
        $FoundThisSlaveNodeId=1;
        last;
     }
  }  
 
  if ( $FoundThisSlaveNodeId==0 ){
      printLog($cpfs3_logname,"Could not find thor slave number for this slave ($ThisSlaveNodesPip). EXITING without copying file parts to S3.\n");
  }
return $thor_slave_number;
}
#-----------------------------------------------------------------------------------
sub get_s3cmd_config{
my ( $juju_unit_number )=@_;
# Setup s3cmd configuration file if it exists.
my $hooks=$hooks_template;
$hooks =~ s/<service>/$service/;
$hooks =~ s/<juju_unit_number>/$juju_unit_number/;
my $cfg = ( -e "$hooks/.s3cfg" )? "--config=$hooks/.s3cfg" : '';

printLog($cpfs3_logname,"In get_s3cmd_config. cfg=\"$cfg\"\n");

if ( $cfg eq '' ){
   printLog($cpfs3_logname,"In get_s3cmd_config. ERROR. The s3cmd config file was NOT found for juju_unit_number=\"$juju_unit_number\".\n");
   exit 1;
}

return $cfg;
}
#-----------------------------------------------------------------------------------
sub FilesOnThor{
my ( $master_pip )=@_;
  # Get list of files on thor
  my @file=split(/\n/,`$dfuplus server=$master_pip action=list name=*`);
  shift @file;
  if ( scalar(@file)==0 ){
     printLog($cp2s3_logname,"In isFilesOnThor. There are no files on this thor.\n");
  }
return @file;
}
#-----------------------------------------------------------------------------------
sub cpAllFilePartsOnS3{
my ( $thor_folder, $s3folder )=@_;
   printLog($cpfs3_logname,"DEBUG: Entering cpAllFilePartsOnS3. thor_folder=\"$thor_folder\", s3folder=\"$s3folder\"\n");
   my $entries=`sudo s3cmd $cfg ls $s3folder/*`;

   my @entry=split(/\n/s,$entries);
   @entry = grep(! /^\s*$/,@entry);
   foreach my $e (@entry){
     printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. entry=\"$e\"\n");
   }

   my $found_at_least_one_part = 0;
   foreach (@entry){
      # Is this entry a directory?
      if ( s/^\s*DIR\s*// ){
         s/\/\s*$//;
         printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. \$_=\"$_\"\n");
         my $subfolder = $1 if /\/([^\/]+)\s*$/;
         printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. subfolder=\"$subfolder\"\n");
         
         if ( ! -e $thor_folder ){
            printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. Saw DIR. system(\"sudo mkdir $thor_folder\")\n");
            system("sudo mkdir $thor_folder"); 
         }
         
         my $newfolder="$thor_folder/$subfolder";
         printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. Calling cpAllFilePartsOnS3(\"$newfolder\",\"$_\");\n");
         cpAllFilePartsOnS3($newfolder,$_);
      }
      else{
         $found_at_least_one_part = 1;
      }
   }

   if ( $found_at_least_one_part ){
      printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. Found at least one file part. So, copying it from S3 to node.\n");
      if ( ! -e $thor_folder ){
         printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. system(\"sudo mkdir $thor_folder\")\n");
         system("sudo mkdir $thor_folder"); 
      }
      printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. system(\"cd $thor_folder;sudo s3cmd $cfg get $s3folder/*\")\n");
      system("cd $thor_folder;sudo s3cmd $cfg get $s3folder/* > /dev/null 2> /dev/null");
   }
   else{
      printLog($cpfs3_logname,"DEBUG: In cpAllFilePartsOnS3. NO FILE PARTS FOR THE FOLDER, $thor_folder.\n");
   }
   printLog($cpfs3_logname,"DEBUG: Leaving cpAllFilePartsOnS3\n");
}

1;