#!/bin/bash
set -ex

rm -rf target/*

mkdir -p target/pubgrid/{0..170}

gunzip -c ukpostcodes.csv.gz | awk -F, -f reduce_precision.awk | awk -F, -f filter_postcodes.awk > target/ukpostcodes.csv
awk -F, -f split_locations.awk target/ukpostcodes.csv

#bash generate_pubs.sh
bash read_pubs.sh

bash build_fsa.sh

awk -F, -f filter_chains.awk target/complete.csv > target/all_chain_pubs.csv
awk -F, -f filter_postcodes.awk target/all_chain_pubs.csv >> target/named_pubs.csv

# process chains without lat/lon
awk -F, -f find_blank_locations.awk target/all_chain_pubs.csv > target/blank_chain_pubs.csv
join -t , -1 2 -2 2 -o 1.1,0,2.3,2.4,1.5,1.6,1.7,1.8,1.9 <(sort -k2,2 -t, target/blank_chain_pubs.csv) <(sort -k2,2 -t, target/ukpostcodes.csv) | awk -F, -f filter_postcodes.awk >> target/named_pubs.csv

cut -f1-4 -d, target/named_pubs.csv | awk -F, -f reduce_precision.awk > target/reduced_pubs.csv

bash build_extra_chains.sh

cat target/reduced_pubs.csv | sort -uf | sort -t, -k2,2 | awk -F, -f split_pubs.awk

#Add additional bits to "outcodes" for non postcode places
awk 'BEGIN { FS="\t"; OFS=","; } $8 ~ /^(PPL|ADM)/ && $5 > 49 && $5 < 61 && $6 > -8 && $6 < 2 { gsub(/[^a-zA-Z0-9]/, "", $2); print $8, $2, $5, $6, $15 }' GB.txt \
| sort -rnk5,5 -t, | cut -f1-4 -d, | tr '[:lower:]' '[:upper:]' | sort -u -k2,2 -t, | awk -F, -f reduce_precision.awk | awk -F, -f split_locations.awk
cat postcode-outcodes.csv | awk -F, -f filter_postcodes.awk | awk -F, -f split_locations.awk

sort -uf target/named_pubs.csv | gzip -c > target/named_pubs.csv.gz

rm target/*.csv target/*.txt

bash build_sitemap.sh

cp index.html target/
cp -R assets/* target/

