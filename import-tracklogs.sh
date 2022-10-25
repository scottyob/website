#!/bin/bash

# cat data/flightlog.json | jq -r 'map(.location) | unique | del(.. | nulls)[]'
cat data/flightlog.json | jq 'map(. + {type: "flightlog", "flying-location": .location})[]' -c | while read line; do
    flightNum=$(echo "${line}" | jq '.flightNumber')
    echo "${line}" > content/flying/flights/${flightNum}.md
done
