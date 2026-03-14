#########################################################################
#Titre: Script de sauvegarde incrémentale pour arborescence "MAILS"     #
#Auteur: Lucas Beneteau                                                 #
#Date de création: 14/08/2025                                           #
#Date de modification: 14/08/2025                                       #
#version: 1.0                                                           #
#                                                                       #
#                                                                       #
#                                                                       #
#                                                                       #
#########################################################################

#!/usr/bin/bash

set -euo pipefail

DATE="$(date '+%F-%T')"
SEMAINE="$(date '+%G-%V-\(%T\)')"
COUNT_FILE="/home/lucas/compteurs/compteur_MAILS"

#Définition Source:
SRC_PATH="/home/lucas/A_SAUVEGARDER/MAILS/" 

#Définition Destination:
DST_HOST="srv-stockage"
DST_USER="user-backup"
DST_SAVE_PATH="/home/user-backup/Sauvegardes/MAILS"
DST_ARCHIVAGE_PATH="/home/user-backup/Archivage/MAILS"

#Préparation Log
LOG_DIR="/home/lucas/saves.log/MAILS"
mkdir -p $LOG_DIR
LOG_FILE="${LOG_DIR}/backup_MAILS_${DATE}.log"

if [ ! -f "$COUNT_FILE" ]; then
	COUNT=0
else 
	read COUNT < "$COUNT_FILE"
fi


if [ "$COUNT" -eq 0 ]; then
	rsync -av --mkpath --chmod=D700,F600 --log-file="${LOG_FILE}" "${SRC_PATH}" "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}/dimanche_COMPLETE"
	COUNT=1
else
	LAST_SAVE="../$(ssh "${DST_USER}@${DST_HOST}" "ls '${DST_SAVE_PATH}' | sort | tail -1")"
	case $COUNT in
		1) jour="lundi" ;;
		2) jour="mardi" ;;
		3) jour="mercredi" ;;
		4) jour="jeudi" ;;
		5) jour="vendredi" ;;
		6) jour="samedi" ;;
	esac

	rsync -av --mkpath --chmod=D700,F600 --log-file="${LOG_FILE}" --link-dest="$LAST_SAVE" "${SRC_PATH}" "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}/${jour}_INCREMENTALE"
	COUNT=$(($COUNT + 1))
fi


if [ "$COUNT" -gt 6 ]; then
	COUNT=0
	ssh "${DST_USER}@${DST_HOST}" "mkdir -p $DST_ARCHIVAGE_PATH/$SEMAINE"
	ssh "${DST_USER}@${DST_HOST}" "mv $DST_SAVE_PATH/* $DST_ARCHIVAGE_PATH/$SEMAINE/"
fi	

echo "$COUNT" > "$COUNT_FILE"

ssh "${DST_USER}@${DST_HOST}" "find ${DST_ARCHIVAGE_PATH} -mindepth 1 -maxdepth 1 -type d -mtime +14 -exec rm -rf {} \;"
