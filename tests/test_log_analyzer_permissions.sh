#!/bin/bash

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cp samples/application.log "$temp_file"
chmod a-r "$temp_file"

output=$(bash scripts/analyze_logs.sh "$temp_file" 2>&1)
status=$?

if printf "%s\n" "$output" | grep -Fqx "Erreur : permission de lecture refusée." && [[ status -eq 3  ]]; then
	echo "PASS: Unreadable file handled correctly"
	exit 0
else
	echo "FAIL"
	exit 1
fi
