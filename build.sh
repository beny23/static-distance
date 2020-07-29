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

gunzip -c ukpostcodes.csv.gz | awk -F, '$3 ~ /^[0-9.-]+$/ && $4 ~ /^[0-9.-]+$/ && $3 < 99.9 { print $0; }' > target/ukpostcodes.csv
awk -F, -f split_outcodes.awk target/ukpostcodes.csv
shuf -n 100000 target/ukpostcodes.csv > target/pubs.csv

shuf -rn 100000 animal_names.txt > target/1.txt
shuf -rn 100000 animal_names.txt > target/2.txt
yes "and" | head -100000 > target/and.txt
paste -d " " target/1.txt target/and.txt target/2.txt > target/pubnames.txt

paste -d "," target/pubnames.txt target/pubs.csv > target/named_pubs.csv

awk -F, -f split_pubs.awk target/named_pubs.csv

cp index.html target

rm target/ukpostcodes.csv target/pubs.csv target/named_pubs.csv target/*.txt
