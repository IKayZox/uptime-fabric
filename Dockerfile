# Base Linux
FROM alpine:3.22

# Installer les dépendances
RUN apk add --no-cache bash curl ca-certificates

# Définir le dossier de travail
WORKDIR /app

# Copier notre script HTTP
COPY scripts/check_http.sh ./scripts/

# Exécuter le script à chaque démarrage
ENTRYPOINT ["bash", "scripts/check_http.sh"]
