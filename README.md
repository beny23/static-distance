To generate outcodes:

```shell script
awk -F, -f split_outcodes.awk ukpostcodes.csv
```

To select 200k postcodes at random

```shell script
shuf -n 200000 ukpostcodes.csv > target/pubs.csv
```

To create a list of random pub names

```shell script
paste -d "," <(paste -d " " <(shuf -r animal_names.txt) <(yes "and") <(shuf -r animal_names.txt) | head -200000) target/pubs.csv > target/named_pubs.csv
```

Explanation: 
- `shuf -r animal_names.txt` creates a list of randomly selected animal names.
- `yes "and"` just repeats "and" over and over
- the `past -d " " ...` concatenates all those, so we get a good combination of fake establishment names

```shell script
$ paste -d " " <(shuf -r animal_names.txt) <(yes "and") <(shuf -r animal_names.txt) | head -10
Flameback and Asiatic leopard
Guillemot and Magpie
Zebra and White ibis
Wallaby and Rabbit
Polecat and Mole
Towhee and Petrel
Wader and Quetzal
Kākāriki and Condor
Piping shrike and Recurvebill
Badger and Zebra
```

- the outer paste, just merges the fake pub names with the previously selected 200k postcodes to derive a list of establishments.

Finding the minimum lat/lon:

```shell script
$ gunzip -dc ukpostcodes.csv.gz | grep -v 99.9999990 | cut -f3 -d, | awk -F, 'BEGIN { max = -999; min = +999; } /[0-9.-]+/ { if ($1 > max) max = $1; if ($1 < min) min = $1; } END { print min, max; }'
49.181941000000000 60.800793046799900
$ gunzip -dc ukpostcodes.csv.gz | grep -v 99.9999990 | cut -f4 -d, | awk -F, 'BEGIN { max = -999; min = +999; } /[0-9.-]+/ { if ($1 > max) max = $1; if ($1 < min) min = $1; } END { print min, max; }'
-8.163139000000000 1.760443184261870
```

Village names pulled from http://download.geonames.org/export/dump/