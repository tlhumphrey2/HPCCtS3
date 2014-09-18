#!/usr/bin/perl
=pod
perl juju-status.pl
perl juju-status.pl tlh-hpcc
=cut

$service = (scalar(@ARGV)>0)? $ARGV[0] : 'tlh-hpcc';

$x=`juju status`;
@x=split(/\n+/,$x);
@status=grep(/^        agent-state|${service}|myhpcc\/|public-address|exposed/,@x);
print join("\n",@status),"\n";

