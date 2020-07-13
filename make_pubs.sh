#!/bin/bash

set -x

outcode_csv=`basename $1`
d1=${outcode_csv:0:1}
d2=${outcode_csv:1:1}
awk -F, -f minmax_outcode.awk $1 | {
  read -r min_lat min_lon max_lat max_lon
  echo "name,postcode,lat,lon" > target/pubs/$d1/$d2/$outcode_csv
  awk -F, -v OFS=, -v min_lat=$min_lat -v max_lat=$max_lat -v min_lon=$min_lon -v max_lon=$max_lon -f filter_pubs.awk target/named_pubs.csv >> target/pubs/$d1/$d2/$outcode_csv
}
