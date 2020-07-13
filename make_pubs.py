import csv

with open('target/named_pubs.csv', newline='') as csvfile:
  pubs = list(csv.reader(csvfile))

for root, dirs, files in os.walk('target/outcode'):
  for file in files:
    with open(os.path.join(root, file), "r") as csvfile:
      reader = csv.reader(csvfile)
      min_lat = +999.99
      min_lon = +999.99
      max_lat = -999.99
      max_lon = -999.99
      miles = 5
      earth_radius = 3960.0
      for i, line in enumerate(reader):
        lat = float(line[2])
        lon = float(line[3])
        if (lat < min_lat):
          min_lat = lat
        if (lon < min_lon):
          min_lon = lon
        if (lat > max_lat):
          max_lat = lat
        if (lon > max_lon):
          max_lon = lon

        with open('target/pubs/' + file[0] + '/' + file[1] + '/' + file, "w") as csvfile:
          regional_pub = filter(lambda i: float(i[2]) > min_lat and float(i[2]) < max_lat and float(i[3]) > min_lon and float(i[3]) < max_lon, pubs)
          for i in regional_pub


