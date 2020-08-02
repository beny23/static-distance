#!/bin/bash
set -ex

curl --fail https://raw.githubusercontent.com/hmrc/eat-out-to-help-out-establishments/20200802/data/participating-establishments/restaurants.csv > target/restaurants.csv
python parse_restaurants.py target/restaurants.csv | sort -u > target/pub_postcodes.csv
touch target/hmrc_parsed.txt