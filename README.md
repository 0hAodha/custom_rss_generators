# custom_rss_generators
A collection of scripts that generate custom RSS feeds

The scripts in this repository do not by default generate output files,
instead only outputting to `stdout`.
This is quite elegant if your RSS feed reader supports reading in from
`stdout` as it avoid the generation of intermediary files.
For example, in my [`newsraft`](https://codeberg.org/newsraft/newsraft) `feeds`
configuration file, I have the following lines:
```
@ Events
$(python3 ~/code/python/custom_rss_generators/roisin_dubh_listings.py 2>/dev/null)  "  Róisín Dubh Event Listings"
```

However, if your RSS feed reader does not support reading in from `stdout` or running 
executables to generate feeds, you will need to find another way to utilise these scripts, e.g.
generating `rss.xml` files on a cron schedule and reading from those in your feed reader by using 
the a link beginning with `file://` or if possible, doing some kind of command injection attack
via your configuration file to force your feed reader to execute the script (although if successful 
& not a deliberate design feature this likely indicates a security issue with your feed reader).
