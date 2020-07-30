import csv
import html

with open('target/restaurants.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, quotechar='"')
    for row in reader:
        name = html.escape(row[0].replace("['\",]", ""))
        postcode = row[5].replace(" ", "").upper()
        outcode = postcode[0:-3]
        incode = postcode[-3:]
        print(name + "," + outcode + " " + incode)