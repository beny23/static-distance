#!/bin/bash
set -ex

rm -rf target/*

tail +2 postcode-outcodes.csv | cut -f2 -d, | while read -r outcode; do
  d1=${outcode:0:1}
  d2=${outcode:1:1}
  mkdir -p target/outcode/$d1/$d2
  mkdir -p target/pubs/$d1/$d2
done
mkdir -p target/outcode/G/I
mkdir -p target/pubs/G/I

gunzip -c ukpostcodes.csv.gz > target/ukpostcodes.csv
awk -F, -f split_outcodes.awk target/ukpostcodes.csv
shuf -n 200000 target/ukpostcodes.csv > target/pubs.csv

paste -d "," <(paste -d " " <(shuf -r animal_names.txt) <(yes "and") <(shuf -r animal_names.txt) | head -200000) target/pubs.csv > target/named_pubs.csv

for f in `find target/outcode -name "*.csv"`
do
  outcode_csv=`basename $f`
  awk -F, -f minmax_outcode.awk $f | {
    read -r min_lat min_lon max_lat max_lon
    echo "name,postcode,lat,lon" > target/pubs/$outcode_csv
    awk -F, -v OFS=, -v min_lat=$min_lat -v max_lat=$max_lat -v min_lon=$min_lon -v max_lon=$max_lon -f filter_pubs.awk target/named_pubs.csv >> target/pubs/$outcode_csv
  }
done

cp index.html target

rm target/ukpostcodes.csv target/pubs.csv target/named_pubs.csv
