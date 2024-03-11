#!/bin/python3

import requests
import json
from datetime import datetime

listings = requests.get("https://roisindubh.net/remote/searchlistings.json").json()["results"]

print('<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">')
print('<channel><title>Roisín Dubh Listings</title><link>https://roisindubh.net/listings/</link>')

for listing in listings:
    print('<item>')
    print('<title>' + listing["pagetitle"] + '</title>')
    print('<link>https://roisindubh.net/listings/' + listing["alias"] + '</link>')
    print('<description>' + listing["introtext"] + '</description>')
    print('<pubDate>' + datetime.strptime(listing["event_date_time"], '%Y-%m-%dT%H:%M:%S').strftime('%a, %d %b %Y %H:%M:%S %z') + '</pubDate>')
    print('</item>')

print('</channel></rss>')
