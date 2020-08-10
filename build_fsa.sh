#/bin/bash
set -ex

cd target
curl -s --fail -L https://ratings.food.gov.uk/open-data/en-gb | grep -Eo 'http://ratings.food.gov.uk/OpenDataFiles/.*\.xml' | grep -v "cy-" | xargs -P20 -n1 -I{} curl -w "%{http_code}" -s --fail -LO {}
cd ..

grep -l FHRSEstablishment target/*.xml | grep -v cy- | xargs xsltproc extract_to_csv.xslt | grep -v '^[^0-9]' | grep -v '^$' | awk -F, '$9' > target/complete.csv

python3 parse_restaurants.py > target/pub_postcodes.csv

python3 match_fsa.py