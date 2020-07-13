BEGIN {
  min_lat = +999.99;
  min_lon = +999.99;
  max_lat = -999.99;
  max_lon = -999.99;
  miles = 5
  earth_radius = 3960.0
  pi = atan2(0, -1)
  degrees_to_radians = pi/180.0
  radians_to_degrees = 180.0/pi
}

NR > 1 && NF == 4 && $1 != "id" {
  if ($3 < min_lat) { min_lat = $3; }
  if ($4 < min_lon) { min_lon = $4; }
  if ($3 > max_lat) { max_lat = $3; }
  if ($4 > max_lon) { max_lon = $4; }
}

END {
  lat_delta = (miles / earth_radius) * radians_to_degrees
  min_r = earth_radius * cos(min_lat * degrees_to_radians)
  min_lon_delta = (miles / min_r) * radians_to_degrees
  max_r = earth_radius * cos(max_lat * degrees_to_radians)
  max_lon_delta = (miles / max_r) * radians_to_degrees
  print min_lat - lat_delta, min_lon - min_lon_delta , max_lat + lat_delta, max_lon + max_lon_delta;
}