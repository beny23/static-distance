import csv

with open('target/restaurants.csv', 'rt') as csvfile:
    reader = csv.reader(csvfile, quotechar='"', quoting=csv.QUOTE_ALL)
    for row in reader:
        name = row[0].replace(",", " ")
        postcode = row[5].replace(" ", "").upper()
        address1 = row[1].replace(",", " ")
        outcode = postcode[0:-3]
        incode = postcode[-3:]
        print(name + "," + address1 + "," + outcode + " " + incode)
