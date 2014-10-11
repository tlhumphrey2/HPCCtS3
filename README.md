HPCCtS3
=======

HPCCtS3, HPCC tied to S3, enables deployment of HPCC to AWS and saving and restoring THOR files to/from S3 buckets.

The big thing that HtS3, the main program of this repository, does is copy to/from S3 buckets, files on the THOR nodes of a deployed HPCC System. What is unique about these copies is that they are done in parallel, which makes them much faster than despraying THOR files to the landing zone and then copying to S3 buckets. This means one can deploy an HPCC system, store its files in S3 buckets, then shutdown the system so additional AWS charges aren't incurred. Then, later have HtS3 bring up another HPCC System with the files restored to it. 

HtS3 also configures and deploys and HPCC System to Amazon's AWS using the HPCC Juju Charm.

Included in this repository is documentation, UsingHtS3.pdf, that tells in great detail how to setup and use HtS3. Also, provided in Appendix B of this documentation is a table that briefly describes all scripts in the repository.

I've also added the document, UsingHPCCCharm.pdf, that tells how to use the HPCC Charm with juju charm to deploy HPCC Systems to AWS and probably others as it gets updated.

