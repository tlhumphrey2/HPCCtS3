#!/usr/bin/perl
# name: cpLZAndMetadataFilesFromS3ToMaster.pl

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '';

require "$thisDir/common.pl";

openLog($cpfs3_logname);

printLog($cpfs3_logname,"Entering cpLZAndMetadataFilesFromS3ToMaster.pl\n");

printLog($cpfs3_logname,"In cpLZAndMetadataFilesFromS3ToMaster.pl. perl $thisDir/cpLZFilesFromS3ToMaster.pl\n");
system("perl $thisDir/cpLZFilesFromS3ToMaster.pl");
printLog($cpfs3_logname,"In cpLZAndMetadataFilesFromS3ToMaster.pl. perl $thisDir/cpMetadataFilesFromS3ToNode.pl\n");
system("perl $thisDir/cpMetadataFilesFromS3ToNode.pl");

system("echo \"done\" > $cpfs3_DoneAlertFile");
printLog($cpfs3_logname,"In cpLZAndMetadataFilesFromS3ToMaster.pl. All copies from S3 completed.\n");
