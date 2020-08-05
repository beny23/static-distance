#!/bin/bash
set -ex

shuf -n 100000 target/ukpostcodes.csv | awk -F, -f filter_postcodes.awk | cut -f2 -d, > target/pub_postcodes.txt

shuf -rn 100000 animal_names.txt > target/1.txt
shuf -rn 100000 animal_names.txt > target/2.txt
yes "and" 2>/dev/null | head -100000 > target/and.txt
paste -d " " target/1.txt target/and.txt target/2.txt > target/pubnames.txt

paste -d "," target/pubnames.txt target/pub_postcodes.txt > target/pub_postcodes.csv
