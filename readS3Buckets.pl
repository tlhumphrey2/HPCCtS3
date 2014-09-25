#!/usr/bin/perl

=pod
./readS3buckets.pl
./readS3buckets.pl s3://tlh_hpcc_esp_backup s3://tlh_hpcc_1_backup s3://tlh_hpcc_2_backup s3://tlh_hpcc_3_backup
=cut

sub readContentsOfS3Bucket{
my ( $s3folder )=@_;
   #print "DEBUG: Entering readContentsOfS3Bucket. s3folder=\"$s3folder\"\n";

   my @entry=split(/\n/s,`sudo s3cmd ls $s3folder/* 2> /dev/null`);
   @entry = grep(! /^\s*$/,@entry);

   my @files=();
   foreach (@entry){
      # At each depth of directory, first check if there are sub-directories. If found, go deeper until there
      #  are no more sub-directories.
      if ( s/^\s*DIR\s*// ){
         s/\/\s*$//;
         my $subfolder = $1 if /\/([^\/]+)\s*$/;
         
         #print "DEBUG: In readContentsOfS3Bucket. Calling readContentsOfS3Bucket(\"$_\");\n";
         readContentsOfS3Bucket($_);
      }
      else{
         $FoundFiles = 1;
         s/^.+s3:/s3:/;
         print "$_\n";
         push @files, $_;
      }
   }

   if ( ! $FoundFiles ){
      print "NO FILES in $s3folder.\n";
   }
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
   local $FoundFiles=0;
   print "Read $_\n";
   readContentsOfS3Bucket($_);
   print "\n";
}
