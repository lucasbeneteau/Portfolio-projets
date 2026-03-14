#########################################################################
#Titre: Script de sauvegarde différentiel des machines virtuelles	#
#Auteur: Lucas Beneteau							#
#Date de création: 14/08/2025						#
#Date de modification: 14/08/2025					#
#version: 1.0								#
#									#
#									#
#									#
#									#
#########################################################################
#!/usr/bin/bash

set -euo pipefail

DATE="$(date '+%T')"
SEMAINE="$(date '+%G-%V-\(%T\)')"
COUNT_FILE="/home/lucas/compteurs/compteur_MACHINES"

#Définition Source:
SRC_PATH="/home/lucas/A_SAUVEGARDER/MACHINES/" 

#Définition Destination:
DST_HOST="srv-stockage"
DST_USER="user-backup"
DST_SAVE_PATH="/home/user-backup/Sauvegardes/MACHINES"
DST_ARCHIVAGE_PATH="/home/user-backup/Archivage/MACHINES"

#Préparation Log
LOG_DIR="/home/lucas/saves.log/MACHINES"
mkdir -p $LOG_DIR
LOG_FILE="${LOG_DIR}/backup_MACHINES_${DATE}.log"


if [ ! -f "$COUNT_FILE" ]; then
	COUNT=0
else 
	read COUNT < "$COUNT_FILE"
fi

ssh "${DST_USER}@${DST_HOST}" '
if [ -d '"$DST_SAVE_PATH"'/*_DIFFERENTIEL ] ; then
    LAST=$(ls -d '"$DST_SAVE_PATH"'/*_DIFFERENTIEL)
    rm -rf "$LAST"
fi
'

if [ "$COUNT" -eq 0 ]; then
	rsync -av --mkpath --chmod=D700,F600 --partial --inplace --log-file="${LOG_FILE}" "${SRC_PATH}" "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}/dimanche_COMPLETE"
	COUNT=1
else
	LAST_COMPLETE="$(ssh "${DST_USER}@${DST_HOST}" "ls -d ${DST_SAVE_PATH}/*_COMPLETE")"

	case $COUNT in
		1) jour="lundi" ;;
		2) jour="mardi" ;;
		3) jour="mercredi" ;;
		4) jour="jeudi" ;;
		5) jour="vendredi" ;;
		6) jour="samedi" ;;
	esac

	rsync -av --mkpath --chmod=D700,F600 --partial --inplace --log-file="${LOG_FILE}" --link-dest="../$(basename "$LAST_COMPLETE")" "${SRC_PATH}" "${DST_USER}@${DST_HOST}:${DST_SAVE_PATH}/${jour}_DIFFERENTIEL"
	COUNT=$(($COUNT + 1))
fi

if [ "$COUNT" -gt 6 ]; then
	COUNT=0
	ssh "${DST_USER}@${DST_HOST}" "mkdir -p $DST_ARCHIVAGE_PATH/$SEMAINE"
	ssh "${DST_USER}@${DST_HOST}" "mv $DST_SAVE_PATH/* $DST_ARCHIVAGE_PATH/$SEMAINE/"
fi	

echo "$COUNT" > "$COUNT_FILE"
