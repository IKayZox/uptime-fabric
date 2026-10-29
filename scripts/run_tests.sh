#!/bin/bash

failed=0

for file in tests/test_*.sh; do
	if bash "$file"; then
		echo "$file -- PASS"
	else
		echo "$file -- FAIL"
		((failed += 1))
	fi
done

if [[ "$failed" -eq 0 ]]; then
	echo "All tests passed"
	exit 0
else
	echo "$failed tests failed"
	exit 1
fi
