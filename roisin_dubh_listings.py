#!/bin/python3
# Script to scrape the event listings webpage for the Róisín Dubh pub in Galway and generate an RSS feed
# The page does appear to offer an RSS feed but it's broken and returns dates in the far future and distant past

import requests
from datetime import datetime

listings = requests.get("https://roisindubh.net/remote/searchlistings.json").json()["results"]

# using several print statements to prioritise code readability over efficiency (I/O speeds are unimportant to me)
print('<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">')
print('<channel><title>Roisín Dubh Listings</title><link>https://roisindubh.net/listings/</link>')

for listing in listings:
    print('<item>')
    print('<title>' + listing["pagetitle"] + '</title>')
    print('<link>https://roisindubh.net/listings/' + listing["alias"] + '</link>')

    print('<description> <![CDATA[')
    print(listing["introtext"] + "\n" + listing["content"] + "\n")

    print('Location: ' + listing["name"] + '<br>')
    print('Ticket Allocation: ' + listing["ticket_allocation"] + '<br>')
    print('Tickets remaining?: ' + str(listing["ticket_remaining"] == '1') + '<br>')
    print('Event start time: ' + listing["event_date_time"] + '<br>')
    print('Late night?: ' + str(listing["late_night"] == "1") + '<br>')
    print('Postponed?: ' + str(listing["postponed"] == "1") + '<br>')
    print('Sales start time: ' + listing["sales_start"] + '<br>')
    print('On Sale?: ' + str(listing["on_sale"] == "1") + '<br>')
    print('Tickets remaining?: ' + str(listing["ticket_remaining"] == '1') + '<br>')

    if listing["external_ticket_url"]:
        print('External Ticket URL: <a href="' + listing["external_ticket_url"] + '">' + listing["external_ticket_url"] + '</a>')

 #  unparsed json object:
 #    "prices": {
 #      "regular": 10,
 #      "student": 0,
 #      "vip": 0,
 #      "ticket_limit": 10,
 #      "ticket_limit_per_transaction": 1,
 #      "discount": []
 #    },

    print(']]> </description>')
    print('<pubDate>' + datetime.strptime(listing["event_date_time"], '%Y-%m-%dT%H:%M:%S').strftime('%a, %d %b %Y %H:%M:%S %z') + '</pubDate>')
    print('</item>')

print('</channel></rss>')
