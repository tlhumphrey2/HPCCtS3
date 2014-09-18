#!/usr/bin/perl
#list_files.pl

$thisDir = ( $0 =~ /^(.+)\// )? $1 : '';

require "$thisDir/common.pl";

($master_pip, @slave_pip)=thor_nodes_ips();

$_=`$dfuplus server=$master_pip action=list name=* 2> /dev/null`;
if ( /List \*/ ){
   print "Got list of files.\n";
}
else{
   print "DID NOT get list of files.\n";
}
