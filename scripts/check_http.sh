#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Erreur : une URL est requise." >&2
	exit 1
fi

if [[ ! "$1" =~ ^https?:// ]]; then
	echo "Erreur : protocole non autorisé (HTTP/HTTPS uniquement)." >&2
	exit 1
fi

sans_protocole="${1#*://}"

autorite="${sans_protocole%%[/?#]*}"

if [[ -z "$autorite" ]]; then
    echo "Erreur : hôte manquant dans l'URL." >&2
    exit 1
fi

if [[ "$autorite" == :* ]]; then
    echo "Erreur : hôte manquant dans l'URL." >&2
    exit 1
fi


echo "URL à vérifier : $1"
http_code=$(curl -sS -o /dev/null  -w "%{http_code}" --max-time 10 --proto '=http,https' --url "$1")
curl_status=$?
echo "Code HTTP : $http_code"
echo "Code retour curl : $curl_status"

if [[ $curl_status -eq 3 ]]; then
	echo "Erreur : URL invalide." >&2
	exit 1
fi

if [[ $curl_status -ne 0 ]]; then
	echo "Statut : DOWN (échec de la requête)" >&2
	exit 2
fi

if [[ $http_code -ge 200 && $http_code -lt 300  ]]; then
	echo "Statut : UP"
	exit 0
else
	echo "Statut : DOWN (code HTTP : $http_code)" >&2
	exit 3
fi
