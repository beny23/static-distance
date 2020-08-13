import csv
import re
import unicodedata
import difflib

from Levenshtein import distance

def normalize_unicode_to_ascii(data):
    normal = unicodedata.normalize('NFKD', data).encode('ASCII', 'ignore')
    val = normal.decode("utf-8")
    val = val.lower()
    # remove special characters
    val = re.sub('[^a-z0-9 ]+', ' ', val)
    # remove multiple spaces
    val = re.sub(' +', ' ', val)
    return val

def normalize(name):
    name = normalize_unicode_to_ascii(re.sub("[']", "", name))
    name = re.sub("(?<![a-z])(the|and|a|by|restaurant|inn|pub|place|cafe|co|ltd|b|bar|restaurants?)(?![a-z])", " ", name)
    return re.sub(" +", " ", name).strip()

def containsMatchingBlock(s1, s2):
    clean1 = normalize(s1)
    clean2 = normalize(s2)

    if (clean1 in clean2 or clean2 in clean1):
        return True

    words1 = clean1.split()
    words2 = clean2.split()

    for w1 in words1:
        for w2 in words2:
            if len(w1) > 3 and len(w2) > 3 and distance(w1, w2) <= 1 + len(w1) // 7:
                return True
    return False

csv.field_size_limit(20000000)

fsa = {}
postcodes = {}

with open('target/complete.csv', 'rt') as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=['id', 'businessId', 'name', 'typeId', 'type', 'addr1', 'addr2', 'addr3', 'postcode', 'ratingValue', 'ratingKey', 'lat', 'lon'])
    for row in reader:
        # see https://ratings.food.gov.uk/business-types/xml
        if row['typeId'] in ['0', '7838', '7842', '7843', '7841', '1', '7844', '4613']:
            postcode = row['postcode']
            if postcode not in fsa:
                fsa[postcode] = []
            fsa[postcode].append(row)
            if "T/A" in row['name'].upper():
                for n in row['name'].upper().split("T/A"):
                    r = row.copy()
                    r['name'] = n
                    fsa[postcode].append(r)

print(f"Read {len(fsa)} FSA records")

with open('target/ukpostcodes.csv', 'rt') as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=['id', 'postcode', 'lat', 'lon'])
    for row in reader:
        postcodes[row['postcode']] = { 'lat': row['lat'], 'lon': row['lon']}

print(f"Read {len(postcodes)} postcodes")

read = 0
written = 0
match_postcode = 0
match_name = 0
match_single_name = 0
unmatched_postcode = 0
blank_postcode = 0
invalid = 0
id = 10000000000
with open('target/named_pubs.csv', 'wt') as outfile:
    writer = csv.DictWriter(outfile, fieldnames=['name', 'postcode', 'lat', 'lon', 'ratingValue', 'ratingKey', 'type', 'typeId', 'id'], quoting=csv.QUOTE_NONE, lineterminator='\n')
    with open('target/pub_postcodes.csv', 'rt') as csvfile:
        reader = csv.DictReader(csvfile, fieldnames=['name', 'addr1', 'postcode'])
        for row in reader:
            read += 1
            postcode = row['postcode']
            found = False

            if postcode in fsa:
                fsainfo = fsa[postcode]

                if len(fsainfo) == 1:
                    match = fsainfo[0]
                    match_postcode += 1
                    found = True
                else:
                    filtered = [d for d in fsainfo if containsMatchingBlock(row['name'], d['name'])]

                    if len(filtered) == 1:
                        match = filtered[0]
                        match_single_name += 1
                        found = True

                    elif len(filtered) > 1:
                        names = [normalize(d['name']) for d in filtered]
                        name = normalize(row['name'])
                        matches = difflib.get_close_matches(name, names, n=1, cutoff=0.8)
                        if len(matches) > 0:
                            closest = matches[0]
                            match = filtered[names.index(closest)]
                            match_name += 1
                            found = True

                if found:
                    if match['lat'] == "" or match['lon'] == "":
                        if postcode in postcodes:
                            postcodeinfo = postcodes[postcode]
                            match['lat'] = postcodeinfo['lat']
                            match['lon'] = postcodeinfo['lon']
                            blank_postcode += 1
                        else:
                            found = False

                if found:
                    writer.writerow(dict(name=re.sub('[,"]', " ", row['name']),
                                         typeId=match['typeId'],
                                         type=match['type'],
                                         postcode=postcode,
                                         ratingValue=match['ratingValue'],
                                         ratingKey=match['ratingKey'],
                                         lat=match['lat'],
                                         lon=match['lon'],
                                         id=match['id']))
                    written += 1

            if not found:
                if postcode in postcodes:
                    postcodeinfo = postcodes[postcode]
                    writer.writerow(dict(name=re.sub('[,"]', " ", row['name']),
                                         typeId='0',
                                         type='unknown',
                                         postcode=postcode,
                                         ratingValue='',
                                         ratingKey='',
                                         lat=postcodeinfo['lat'],
                                         lon=postcodeinfo['lon'],
                                         id = id))
                    id += 1
                    written += 1
                    found = True
                    unmatched_postcode += 1

            if not found:
                invalid += 1

print(f'Read {read} EOTHO records')
print(f'Written {match_postcode} records by postcode only')
print(f'Written {match_name} records by name and postcode')
print(f'Written {match_single_name} records by single name and postcode')
print(f'Recovered {blank_postcode} blank postcode records')
print(f'Written {unmatched_postcode} unmatched records with postcode')
print(f'Not written {invalid} EOTHO unmatched records with invalid or no postcode')
print(f'Written {written} EOTHO records')