> :warning: **ARCHIVED**: This is now abandoned, website is now moved to [https://github.com/scottyob/nextjs-website](https://github.com/scottyob/nextjs-website)


Just my website https://www.scottyob.com/

## Flightlogs

This website is also used to keep track of my paragliding flight logs.  This is typically under the flying directory

The following assumes that you have the [IGC Logbook Generator](https://github.com/scottyob/igc-logbook-generator) setup in your home directory.

### To (re)-generate the launches files
```
scott@ScottoDesktop:~/website$ unzip -p content/flying/launches/paraglidingspots_2022_10_22.kmz doc.kml |  ~/.local/bin/xq | sed 's/kml\://' | jq '[.. | .Placemark? // empty] | flatten | map((.Point | .coordinates | split(",")?) as $c | {name, longitude: ($c[0] | tonumber), latitude: ($c[1] | tonumber) })' > ./content/flying/launches/launches.json
```

### To generate the flightlog
```
~/igc-logbook-generator/node_modules/.bin/ts-node ~/igc-logbook-generator/index.ts build ./content/flying/tracklogs --launchesFile ./content/flying/launches/launches.json --sitesFile ./content/flying/launches/sites.json | jq > ./data/flightlog.json
```
```
./import-tracklogs.sh
```


## TODOs
- Recipes need to have tag taxonomy filtering.

