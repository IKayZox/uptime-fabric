#!/bin/bash

mock_dir=$(mktemp -d) || exit 1
trap 'rm -rf "$mock_dir"' EXIT

cat > "$mock_dir/curl" <<'EOF'
#!/bin/bash
printf '%s' "$MOCK_HTTP_CODE"
exit "$MOCK_CURL_EXIT"
EOF

chmod +x "$mock_dir/curl" || exit 1

output=$(MOCK_HTTP_CODE=503 MOCK_CURL_EXIT=0  PATH="$mock_dir:$PATH" bash scripts/check_http.sh "https://example.invalid/health" 2>&1)
status=$?

if printf "%s\n" "$output" | grep -Fxq "Code HTTP : 503" &&
        printf "%s\n" "$output" | grep -Fxq "Code retour curl : 0" &&
        printf "%s\n" "$output" | grep -Fxq "Statut : DOWN (code HTTP : 503)" &&
        [[ $status -eq 3 ]]; then
    echo "PASS: HTTP 503 reported as DOWN"
else
    echo "FAIL: HTTP 503 was not reported as DOWN" >&2
    exit 1
fi

output=$(MOCK_HTTP_CODE=000 MOCK_CURL_EXIT=7 PATH="$mock_dir:$PATH" bash scripts/check_http.sh "https://example.invalid/health" 2>&1)
status=$?

if printf "%s\n" "$output" | grep -Fxq "Code HTTP : 000" &&
        printf "%s\n" "$output" | grep -Fxq "Code retour curl : 7" &&
        printf "%s\n" "$output" | grep -Fxq "Statut : DOWN (échec de la requête)" &&
        [[ $status -eq 2 ]]; then
    echo "PASS: Connection failure handled correctly"
else
    echo "FAIL: Connection failure not handled correctly" >&2
    exit 1
fi

exit 0
