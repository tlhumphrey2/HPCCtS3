#!/usr/bin/perl

=pod
./rmS3bucket.pl
./rmS3Bucket.pl s3://tlh_hpcc_esp_backup s3://tlh_hpcc_1_backup s3://tlh_hpcc_2_backup s3://tlh_hpcc_3_backup
=cut

sub rmContentsOfS3Bucket{
my ( $s3folder )=@_;
   #print "DEBUG: Entering rmContentsOfS3Bucket. s3folder=\"$s3folder\"\n";

   my @entry=split(/\n/s,`sudo s3cmd ls $s3folder/* 2> /dev/null`);
   @entry = grep(! /^\s*$/,@entry);
   foreach my $e (@entry){
     #print "DEBUG: In rmContentsOfS3Bucket. entry=\"$e\"\n";
   }

   my $found_at_least_one_filepart = 0;
   my @files=();
   foreach (@entry){
      # At each depth of directory, first check if there are sub-directories. If found, go deeper until there
      #  are no more sub-directories.
      if ( s/^\s*DIR\s*// ){
         s/\/\s*$//;
#print "DEBUG: In rmContentsOfS3Bucket. \$_=\"$_\"\n";
         my $subfolder = $1 if /\/([^\/]+)\s*$/;
#print "DEBUG: In rmContentsOfS3Bucket. subfolder=\"$subfolder\"\n";
         
         #print "DEBUG: In rmContentsOfS3Bucket. Calling rmContentsOfS3Bucket(\"$_\");\n";
         rmContentsOfS3Bucket($_);
      }
      else{
         $found_at_least_one_filepart = 1;
         s/^.+s3:/s3:/;
         push @files, $_;
      }
   }

   if ( $found_at_least_one_filepart ){
      #print "DEBUG: In rmContentsOfS3Bucket. Found the following files in $s3folder\n";
      print "Removing: ",join("\nRemoving: ",@files),"\n";
      print("s3cmd del $s3folder/*\n\n");
      system("s3cmd del $s3folder/* 2> /dev/null");
      if ( $s3folder ne $s3bucket ){
        print("s3cmd del $s3folder\n\n");
        system("s3cmd del $s3folder 2> /dev/null");
      }
   }
   else{
      print "NO FILES in $s3folder.\n";
      if ( $s3folder ne $s3bucket ){
        print("s3cmd del $s3folder\n\n");
        system("s3cmd del $s3folder 2> /dev/null");
      }
   }

   if ( $s3folder eq $s3bucket ){
      print("s3cmd rb $s3bucket\n");
      system("s3cmd rb $s3bucket 2> /dev/null");
   }
   #print "DEBUG: Leaving rmContentsOfS3Bucket\n";
}

sub getAllHPCCS3Buckets{
  local $_=`s3cmd ls s3:|egrep tlh`;
  s/^\n+//;
  s/\n+$//;
  my @b=split(/\n/,$_);
  return grep(s/^.+s3:/s3:/,@b);
}

@S3BucketsToRemove = (scalar(@ARGV)==0)? getAllHPCCS3Buckets() : @ARGV;
foreach (@S3BucketsToRemove){
   local $s3bucket=$_;
   print "Removing $_\n";
   rmContentsOfS3Bucket($_);
}
