#!/usr/bin/perl
# Script to scrape the Irish dictionary website teanglann.ie and turn the "Word of the Day" into an RSS item
use strict;
use warnings;
use HTML::TreeBuilder;
use Encode;

# use UTF-8 when writing to STDOUT
binmode(STDOUT, ":encoding(utf8)"); 

my $url  = "https://www.teanglann.ie/en/";
my $html = `curl "$url"`;

my $tree = HTML::TreeBuilder->new;
$tree->parse(decode('UTF-8', $html));
$tree->eof;

my $div   = $tree->look_down(_tag => "div",  class => "wod");
my $a_tag =  $div->look_down(_tag => "a",    class => "headword");
my $entry =  $div->look_down(_tag => "span", class => "entry");

my $word  = $a_tag->as_text;
my $link  = $a_tag->attr("href");

print("
<rss xmlns:atom='http://www.w3.org/2005/Atom' version='2.0'>
<channel>
    <title>Teanglann.ie: Focal an Lae</title>
    <link>" . $url . "</link>

    <item>
        <title>" . $word . "</title>
        <link>https://www.teanglann.ie" . $link . "</link>
        <pubDate>" . `date "+%a, %d %b %Y %H:%M:%S %z"` . "</pubDate>
        <description><![CDATA[" . $entry->as_text . "]]></description>
    </item>
</channel>
</rss>
");

$tree = $tree->delete;
