#!/usr/bin/perl
use strict;
use warnings;

use utf8;
use JSON;
use Date;
use Date::Parse;

# use UTF-8 when writing to STDOUT
binmode(STDOUT, ":encoding(utf8)");

sub yes_or_no {
    my ($boolean) = @_;
    return($boolean eq "1" ? "Yes" : "No");
}

my $listings = decode_json(`curl "https://roisindubh.net/remote/searchlistings.json"`)->{results};

print("
<rss xmlns:atom='http://www.w3.org/2005/Atom' version='2.0'>
<channel><title>Róisín Dubh Listings</title><link>https://roisindubh.net/listings/</link>");

foreach my $listing (@$listings) {
    my $event_date = str2time($listing->{event_date_time});

    # only print data if event data is in the future
    if ($event_date > Date::now()) {
        print("
        <item>
            <title><![CDATA[" . $listing->{pagetitle} . "]]></title>
            <link>https://roisindubh.net/listings/" . $listing->{alias} . "</link>
            <pubDate>" . Date::strftime("%a, %d %b %Y %H:%M:%S %z", $event_date) . "</pubDate>

            <description>
                <![CDATA[
                    " . $listing->{introtext} . "

                    " . $listing->{content} . "

                Location: " . $listing->{name} . "<br>
                Event start time: " . Date::strftime("%Y-%m-%d %a %H:%M:%S", $event_date) . "<br>
                Late night?: " . yes_or_no($listing->{late_night}) . "<br>
                Postponed?: " . yes_or_no($listing->{postponed}) . "<br>
<br>
                Ticket Price: €" . $listing->{prices}->{regular} . "<br>
                Ticket Allocation: " . $listing->{ticket_allocation} . "<br>
                Tickets remaining?: " . yes_or_no($listing->{ticket_remaining}) . "<br>
<br>
                Sales start time: " . Date::strftime("%Y-%m-%d %a %H:%M:%S", str2time($listing->{sales_start})) . "<br>
                On Sale?: " . yes_or_no($listing->{on_sale}) . "<br>
                ]]>
            </description>
        </item>
        ");
    }
}
print("</channel></rss>");
