$4 > min_lat && $4 < max_lat && $5 > min_lon && $5 < max_lon {
  print $1, $3, $4, $5
}