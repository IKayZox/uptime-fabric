#!/bin/bash

# Exécuter check_http.sh sans argument
output=$(bash scripts/check_http.sh 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : une URL est requise." && [[ $status -eq 1 ]]; then
	echo "PASS: Missing URL handled correctly"
else
	echo "FAIL: Missing URL not handled correctly" >&2
	exit 1
fi


# Exécuter check_http.sh avec 2 arguments
output=$(bash scripts/check_http.sh https://example.com https://httpbin.org 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : une URL est requise." && [[ $status -eq 1 ]]; then
	echo "PASS: Multiple URLs rejected correctly"

else
	echo "FAIL: Multiple URLs not handled correctly" >&2
	exit 1
fi

# Exécuter check_http.sh avec une URL non http
output=$(bash scripts/check_http.sh "ftp://example.com" 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : protocole non autorisé (HTTP/HTTPS uniquement)." && [[ $status -eq 1 ]]; then
        echo "PASS: Unsupported protocol rejected correctly"

else
        echo "FAIL: Unsupported protocol was not rejected correctly" >&2
        exit 1
fi

# Vérifier une URL sans hôte
output=$(bash scripts/check_http.sh "https://" 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : hôte manquant dans l'URL." && [[ $status -eq 1 ]]; then
        echo "PASS: Missing host rejected correctly"

else
        echo "FAIL: Missing host not handled correctly" >&2
        exit 1
fi

# Vérifier une URL avec un port mais sans hôte
output=$(bash scripts/check_http.sh "https://:8080" 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : hôte manquant dans l'URL." && [[ $status -eq 1 ]]; then
        echo "PASS: Port without host rejected correctly"

else
        echo "FAIL: Port without host not handled correctly" >&2
        exit 1
fi

# Vérifier une URL avec un port invalide
output=$(bash scripts/check_http.sh "https://example.com:abc" 2>&1)
status=$?

# Vérifier le message d'erreur et le code retour
if printf '%s\n' "$output" | grep -Fxq "Erreur : URL invalide." && [[ $status -eq 1 ]]; then
        echo "PASS: Invalid port rejected correctly"

else
        echo "FAIL: Invalid port not handled correctly" >&2
        exit 1
fi

exit 0
