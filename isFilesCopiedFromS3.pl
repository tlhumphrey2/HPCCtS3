#!/usr/bin/perl
require "/home/user/thor_info.pl";
sub isFilesCopiedFromS3{\
my ( $service, @units )=@_;
  my @not_copied_units=();
  foreach my $u (@units){
     $_=`juju ssh ${service}/$u /var/lib/juju/agents/unit-${service}-$u/charm/hooks/isFilesCopiedFromS3.sh 2> /dev/null`;
     if ( ! /Files copied from S3 to this unit/ ){
        print "${service}/$u S3 has NOT copied its files to node.\n";
        push @not_copied_units, $u;
     }
     else{
        print "${service}/$u S3 has copied its files to node.\n";
     }
  }

@units = @not_copied_units;
return @units;
}


sub loopUntilAllFilesCopiedFromS3{
my ( $service )=@_;

my @units = @slave_unit_numbers;
unshift @units, $esp_unit_number;

do{
   @units = isFilesCopiedFromS3($service, @units);
} while ( scalar(@units) != 0 );

print "All Files Have Been Copied from S3.\n";
}
