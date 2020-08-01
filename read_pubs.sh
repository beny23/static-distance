#!/bin/bash
set -ex

curl https://raw.githubusercontent.com/hmrc/eat-out-to-help-out-establishments/master/data/participating-establishments/restaurants.csv > target/restaurants.csv
python parse_restaurants.py target/restaurants.csv | sort -u > target/pub_postcodes.csv
touch target/hmrc_parsed.txt