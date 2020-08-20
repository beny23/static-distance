#!/bin/bash

extra_chains=(
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/burger-king/burger-king-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/costa-coffee/costa-coffee-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/kfc/kfc-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/mcdonalds/mcdonalds-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/nandos/nandos-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/pret/pret-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/wetherspoon/wetherspoon-eotho.csv"
  "https://raw.githubusercontent.com/fryford/eatouttohelpout/master/chain-restaurants/whitbread/whitbread-eotho.csv"
)
for f in ${extra_chains[*]}
do
  echo "Processing $f"
  curl --fail -L $f | tail -n +2 | cut -f1,6,7,8 -d, | awk -F, -f reduce_precision.awk >> target/reduced_pubs.csv
done
