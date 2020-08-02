#!/bin/bash
set -ex

rm -rf target/*

for d in `seq 0 170`
do
  mkdir -p target/pubgrid/$d
done

gunzip -c ukpostcodes.csv.gz | awk -F, -f filter_postcodes.awk > target/ukpostcodes.csv
awk -F, -f split_locations.awk target/ukpostcodes.csv

#bash generate_pubs.sh
bash read_pubs.sh

join -t , -1 2 -2 2 -o 1.1,0,2.3,2.4 <(sort -k 2 -t , target/pub_postcodes.csv) <(sort -k 2 -t , target/ukpostcodes.csv) > target/named_pubs.csv

awk -F, -f filter_postcodes.awk target/named_pubs.csv | awk -F, -f split_pubs.awk

#Add additional bits to "outcodes" for non postcode places
awk 'BEGIN { FS="\t"; OFS=","; } $8 ~ /^(PPL|ADM)/ && $5 > 49 && $5 < 61 && $6 > -8 && $6 < 2 { gsub(/[^a-zA-Z0-9]/, "", $2); print $8, $2, $5, $6 }' GB.txt | tr '[:lower:]' '[:upper:]' | sort -u -k2,2 -t, | awk -F, -f split_locations.awk
cat postcode-outcodes.csv | awk -F, -f filter_postcodes.awk | awk -F, -f split_locations.awk

rm target/*.csv target/*.txt

cp index.html target/
cp assets/* target/

