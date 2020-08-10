#/bin/bash
set -ex

curl --fail -L https://raw.githubusercontent.com/beny23/static-distance-fsa/gh-pages/complete.csv.gz | gunzip -dc > target/complete.csv

python3 parse_restaurants.py > target/pub_postcodes.csv

python3 match_fsa.py