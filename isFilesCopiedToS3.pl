#!/usr/bin/perl
require "/home/user/thor_info.pl";
sub isFilesCopiedToS3{
my ( $service, @units )=@_;
  $AllFilesCopiedToS3=1;
  my @not_copied_units=();
  foreach my $u (@units){
     $_=`juju ssh ${service}/$u /var/lib/juju/agents/unit-${service}-$u/charm/hooks/isFilesCopiedToS3.sh`;
     if ( ! /Files copied to S3 from this unit/ ){
        print "${service}/$u has NOT copied its files to S3.\n";
        $AllFilesCopiedToS3=0;
        push @not_copied_units, $u;
     }
     else{
        print "${service}/$u has copied its files to S3.\n";
     }
  }

  @units = @not_copied_units;
return @units;
}

sub loopUntilAllFilesCopiedToS3{
my ( $service )=@_;

my @units = @slave_unit_numbers;
unshift @units, $esp_unit_number;

do{
   @units=isFilesCopiedToS3($service,@units);
} while ( scalar(@units) != 0 );

print "All Files Have Been Copied to S3.\n";
}