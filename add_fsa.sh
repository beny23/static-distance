#!/bin/bash

curl --fail https://raw.githubusercontent.com/exussum12/fsa-data/master/processed/basic.csv.gz > target/fsa.csv.gz 
php match.php target/fsa.csv.gz target/named_pubs.csv > target/named_pubs.tmp.csv
mv target/named_pubs.tmp.csv target/named_pubs.csv

rm target/fsa.csv.gz
