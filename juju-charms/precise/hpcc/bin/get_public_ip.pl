#!/usr/bin/perl
=pod
./get_public_ip.pl "tlh-hpcc/2"
=cut

$unit_name = shift @ARGV;

$_=`juju status 2> /dev/null`;

@x = split(/\n+/,$_);

$u = $unit_name;
$u =~ s/\//\\\//;
$u =~ s/\-/\\\-/;
$found_unit=0;
foreach (@x){
  if ( $found_unit ){
    if ( /public\-address/ ){
       my $ip = $1 if /(\d+(\-\d+){3})\./;
       $ip =~ s/\-/\./g;
       print "$ip\n";
       exit;
    }
  }
  elsif (! $found_unit && /\b$u\b/ ){
    $found_unit=1;
  }
}
