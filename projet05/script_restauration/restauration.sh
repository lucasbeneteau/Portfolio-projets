#########################################################################
#Titre: Script de restauration des données.				#
#Auteur: Lucas Beneteau							#
#Date de création: 18/08/2025						#
#Date de modification: 20/08/2025					#
#version: 1.0								#
#									#
#									#
#									#
#									#
#########################################################################
#!/usr/bin/bash

set -euo pipefail

DATE="$(date '+%T')"

#Définition coté client:
SRC_PATH="/home/lucas/A_SAUVEGARDER" 

#Définition coté serveur:
DST_HOST="srv-stockage"
DST_USER="user-backup"
DST_SAVE_PATH="/home/user-backup/Sauvegardes"

#Préparation Log
LOG_DIR="/home/lucas/restauration.log"
mkdir -p $LOG_DIR

cat <<'EOF'
Entrer le chemin (dossier OU fichier) à récupérer à partir de l'arborescence concernée.
Exemples (attention aux "/") :
/SITE/2025-08-18-13:49:55_COMPLETE/
/SITE/2025-08-18-13:49:55_COMPLETE/CSS/TEST/default.css

EOF

read RST_PATH

TREE=$(echo "$RST_PATH" | cut -d"/" -f2)
CHEMIN="${RST_PATH#/*/*/}"
if [[ ! $CHEMIN ]] ; then
	CHEMIN=""
elif [[ ! $CHEMIN == */ ]] ; then
	CHEMIN="$(dirname "$CHEMIN")/" 
fi

DEST="${SRC_PATH}/${TREE}/${CHEMIN}"

LOG_FILE="${LOG_DIR}/restauration_${TREE}_${DATE}.log"

#printf '\nVous avez saisi : %s\n' "$RST_PATH"
printf 'Le chemin de destination cible sera : %s\n' "$DEST"

printf '\nDRY RUN:\n'
rsync -avn --itemize-changes "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}${RST_PATH}" "$DEST"
printf '\n'

read -p "Confirmer le dry run et écrire les données ? (o/n) : " confirm

if [[ ! "$confirm" =~ ^[oO]$ ]]; then
  echo "Annulé !"
  exit 1
fi

rsync -av --itemize-changes --log-file="${LOG_FILE}" "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}${RST_PATH}" "$DEST" 
