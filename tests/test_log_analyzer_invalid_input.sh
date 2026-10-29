#!/bin/bash

output=$(bash scripts/analyze_logs.sh 2>&1)
status=$?

if printf '%s\n' "$output" | grep -Fxq "Erreur : vous devez fournir un fichier." && [[ $status -eq 1 ]]; then
	echo "PASS: Missing argument handled correctly"
else
	echo "FAIL"
	exit 1
fi

output=$(bash scripts/analyze_logs.sh samples/inexistant.log 2>&1)
status=$?

if printf '%s\n' "$output" | grep -Fxq "Erreur : le fichier n'existe pas." && [[ $status -eq 2 ]]; then
        echo "PASS: Missing file handled correctly"
else
        echo "FAIL"
        exit 1
fi

exit 0
