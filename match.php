<?php
require_once  __DIR__ . '/FsaMatch.php';

if (!isset($argv[1], $argv[2])) {
	echo "Please call with 1 being FSA data, 2 being HMRC data. Stdout will contain the merged info";
	exit (1);
}
$fsa = $argv[1];
$hmrc = $argv[2];

if(!file_exists($fsa)) {
	echo "FSA file not found";
	exit(1);
}

if(!file_exists($hmrc)) {
	echo "HMRC file not found";
	exit(1);
}


$match = new FsaMatch\FsaMatch($fsa);

$file = fopen($hmrc, 'r');
$headers = [
	'name',
	'postcode',
	'lat',
	'long'
];
while(($line = fgetcsv($file)) !== false) {
	$line = array_combine($headers, $line);
	$line['rating'] = -1;
	$line['cat'] = 'Unknown';
	if ($found = $match->match($line['name'], $line['postcode'])) {
		if (
			$found['lat'] > 49 && $found['lat'] < 61 &&
			$found['long'] > -8 && $found['long'] < 2
		) { 
			$line['lat'] = $found['lat'];
			$line['long'] = $found['long'];
		}
		$line['rating'] = $found['rating'];
		$line['cat'] = $found['type'];
	}
	$line = array_values($line);
	printf("%s,%s,%.4f,%.4f,%d,%s\n", ...$line);
}
