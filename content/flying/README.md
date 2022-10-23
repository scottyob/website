---
date: 2022-10-21
title: Readme
---

This directory contains my flying related flightlog.

The scripts here will setup pages for all the sites I've flown at, and flight statistics for them.

### To (re)-generate the launches files
```
scott@ScottoDesktop:~/website$ unzip -p content/flying/launches/paraglidingspots_2022_10_22.kmz doc.kml |  ~/.local/bin/xq | sed 's/kml\://' | jq '[.. | .Placemark? // empty] | flatten | map((.Point | .coordinates | split(",")?) as $c | {name, longitude: ($c[0] | tonumber), latitude: ($c[1] | tonumber) })' > ./content/flying/launches/launches.json
```

### To generate the flightlog
```
scott@ScottoDesktop:~/website$ ./content/flying/generator/node_modules/.bin/ts-node ./content/flying/generator/index.ts build ./content/flying/tracklogs --launchesFile ./content/flying/launches/launches.json --sitesFile ./content/flying/launches/sites.json | jq > ./data/flightlog.json
```