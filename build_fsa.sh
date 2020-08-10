#/bin/bash
set -ex

curl https://github.com/beny23/static-distance-fsa/blob/gh-pages/complete.csv.gz?raw=true | gunzip -dc > target complete.csv

python3 parse_restaurants.py > target/pub_postcodes.csv

python3 match_fsa.py