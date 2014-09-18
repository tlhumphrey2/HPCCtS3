#!/bin/bash -e
for file in "$@"
do
  echo "Processing: $file";
  sed -e "s/juju-log \"/juju-log \"In $file. /g" $file > tt1;
  head -1 tt1 > head_tt1;
  echo "juju-log \"Entering $file\"" > entering;
  x=$((($(wc -l tt1|sed -e "s/^\([0-9][0-9]*\).*/\1/"))-1))
  tail -$x tt1 > tail_tt1;
  echo "juju-log \"Leaving $file\"" > leaving;
  cat head_tt1 entering tail_tt1 leaving > tt2;
  mv -f tt2 $file;
done
