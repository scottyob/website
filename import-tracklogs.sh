#!/bin/bash

cat data/flightlog.json | jq -r 'map(.location) | unique | del(.. | nulls)[]'