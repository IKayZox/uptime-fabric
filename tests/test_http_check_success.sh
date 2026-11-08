#!/bin/bash

mock_dir=$(mktemp -d) || exit 1
trap 'rm -rf "$mock_dir"' EXIT

cat > "$mock_dir/curl" <<'EOF'
#!/bin/bash
printf '%s' "$MOCK_HTTP_CODE"
exit "$MOCK_CURL_EXIT"
EOF

chmod +x "$mock_dir/curl" || exit 1

output=$(MOCK_HTTP_CODE=200 MOCK_CURL_EXIT=0  PATH="$mock_dir:$PATH" bash scripts/check_http.sh "https://example.invalid/health" 2>&1)
status=$?

if printf "%s\n" "$output" | grep -Fxq "Code HTTP : 200" &&
	printf "%s\n" "$output" | grep -Fxq "Code retour curl : 0" &&
	printf "%s\n" "$output" | grep -Fxq "Statut : UP" &&
	[[ $status -eq 0 ]]; then
    echo "PASS: HTTP 200 reported as UP"
else
    echo "FAIL: HTTP 200 was not reported as UP" >&2
    exit 1
fi

exit 0
