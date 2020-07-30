#!/bin/bash
set -ex

rm -rf target/*

tail +2 postcode-outcodes.csv | cut -f2 -d, | while read -r outcode; do
  d1=${outcode:0:1}
  d2=${outcode:1:1}
  mkdir -p target/outcode/$d1/$d2
done
for d in `seq 0 170`
do
  mkdir -p target/pubgrid/$d
done

gunzip -c ukpostcodes.csv.gz | awk -F, -f filter_postcodes.awk > target/ukpostcodes.csv
awk -F, -f split_outcodes.awk target/ukpostcodes.csv

bash generate_pubs.sh

join -t , -1 2 -2 2 -o 1.1,0,2.3,2.4 <(sort -k 2 -t , target/pub_postcodes.csv) <(sort -k 2 -t , target/ukpostcodes.csv) > target/named_pubs.csv

awk -F, -f filter_postcodes.awk target/named_pubs.csv | awk -F, -f split_pubs.awk

cp index.html target
cp eotho.png target

rm target/*.csv target/*.txt
