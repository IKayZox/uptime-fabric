#!/bin/bash

output=$(bash scripts/analyze_logs.sh samples/application.log)
status=$?

if [[ status -ne 0 ]]; then
	echo "FAIL: Unexpected exit status" >&2
	exit 1
elif ! printf '%s\n' "$output" | grep -Fxq "Nombre d'erreurs: 3"; then
	echo "FAIL: Unexpected error count" >&2
        exit 1
elif ! echo "$output" | grep -Fxq "Nombre de warning: 1"; then
	echo "FAIL: Unexpected warning count" >&2
        exit 1
else
	echo "PASS: Log analyzer returns expected results"
        exit 0
fi

