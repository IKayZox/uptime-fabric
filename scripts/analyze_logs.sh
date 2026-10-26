#!/bin/bash
if [[ $# -eq 1 ]]; then
	if [[ -f "$1" ]]; then
		if [[ ! -r "$1" ]]; then
			echo "Erreur : permission de lecture refusée." >&2
			exit 3
	        fi
		echo "Fichier analysé : $1"
		nb_errors=$(grep -c '^ERROR ' "$1")
		status_infos=$?
		if [[ status_infos -gt 1 ]]; then
			echo "Erreur : échec de l'analyse des logs." >&2
			exit 4
		fi
		nb_warning=$(grep -c '^WARNING ' "$1")
		status_infos=$?
		if [[ status_infos -gt 1 ]]; then
                        echo "Erreur : échec de l'analyse des logs." >&2
                        exit 4
                fi
		echo "Nombre d'erreurs: $nb_errors"
		echo "Nombre de warning: $nb_warning"
		exit 0
	else
		echo "Erreur : le fichier n'existe pas." >&2
		exit 2
	fi
else
	echo -e "Erreur : vous devez fournir un fichier.\nUtilisation : $0 <fichier>" >&2
	exit 1
fi
