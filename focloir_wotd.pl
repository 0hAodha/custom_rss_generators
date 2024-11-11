#!/usr/bin/perl
# Script to scrape the Irish dictionary website focloir.ie and turn the "Word of the Day" into an RSS item
use strict;
use warnings;
use HTML::TreeBuilder;
use Encode;

# use UTF-8 when writing to STDOUT
binmode(STDOUT, ":encoding(utf8)"); 

my $url = "https://www.focloir.ie/en/";
my $user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"; # focloir.ie blocks curl and wget without this
my $html = `curl --user-agent "$user_agent" "$url"`;

my $tree = HTML::TreeBuilder->new;
$tree->parse(decode('UTF-8', $html));
$tree->eof;

my $div   = $tree->look_down(_tag => "div", class => "wotdEntry");
my $a_tag = $div->look_down(_tag => "div", class => "wotdEntryHdr")->look_down(_tag => "a");

my $word  = $a_tag->look_down(_tag => "span")->as_text;
my $link  = $a_tag->attr("href");
my $entry = $div->look_down(_tag => "div", class => "wotdEntryBody")->as_text;

print("
<rss xmlns:atom='http://www.w3.org/2005/Atom' version='2.0'>
<channel>
    <title>Focloir.ie: Focal an Lae</title>
    <link>" . $url . "</link>

    <item>
        <title>" . $word . "</title>
        <link>" . $link . "</link>
        <pubDate>" . `date "+%a, %d %b %Y %H:%M:%S %z"` . "</pubDate>
        <description><![CDATA[" . $word . "<br>" . $entry . "]]></description>
    </item>
</channel>
</rss>
");

$tree = $tree->delete;
