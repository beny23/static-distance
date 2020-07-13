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

gunzip -c ukpostcodes.csv.gz | awk -F, '$3 ~ /^[0-9.-]+$/ && $4 ~ /^[0-9.-]+$/ { print $0; }' > target/ukpostcodes.csv
awk -F, -f split_outcodes.awk target/ukpostcodes.csv
shuf -n 200000 target/ukpostcodes.csv > target/pubs.csv

paste -d "," <(paste -d " " <(shuf -r animal_names.txt) <(yes "and") <(shuf -r animal_names.txt) | head -200000) target/pubs.csv > target/named_pubs.csv

find target/outcode -name "*.csv" -print0 | xargs -0 -n1 -P8 -I{} bash make_pubs.sh {}

cp index.html target

rm target/ukpostcodes.csv target/pubs.csv target/named_pubs.csv
