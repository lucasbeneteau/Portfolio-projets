#!/usr/bin/env bash

#=================== 
#Auteur		: Lucas Beneteau
#Version:	: 1.0
#Date		: 2025-07-09
#Description	  Script d'installation montage logon CIFS pour utilisateurs AD.
#		  On utilise Pam_exec.
#====================

#PARAMETRES

SERVEUR="srv-dc.barzini.local"
PARTAGE_COMMUNS="Communs"
PARTAGE_UTILISATEUR="Utilisateurs"
MONTAGE_LOCAL="$HOME/PARTAGE_BARZINI"
SAMACCOUNTNAME=${PAM_USER%%@*}
PARTAGES=(
  "$PARTAGE_COMMUNS/Developpement:$MONTAGE_LOCAL/Developpement:developpeurs,managers"
  "$PARTAGE_COMMUNS/Audio:$MONTAGE_LOCAL/Audio:audio,developpeurs,managers"
  "$PARTAGE_COMMUNS/Graphisme:$MONTAGE_LOCAL/Graphisme:graphistes,developpeurs,managers"
  "$PARTAGE_COMMUNS/Communication:$MONTAGE_LOCAL/Communication:communication,managers"
  "$PARTAGE_COMMUNS/Direction:$MONTAGE_LOCAL/Direction:direction,managers"
  "$PARTAGE_COMMUNS/Informatique:$MONTAGE_LOCAL/Informatique:informatique,managers"
  "$PARTAGE_COMMUNS/Production:$MONTAGE_LOCAL/Production:production,managers"
  "$PARTAGE_COMMUNS/Technique:$MONTAGE_LOCAL/Technique:technique,managers"
  "$PARTAGE_COMMUNS/Test:$MONTAGE_LOCAL/Test:testeurs,managers"

  "$PARTAGE_UTILISATEUR/$SAMACCOUNTNAME:$MONTAGE_LOCAL/Perso:utilisateurs du domaine"
)
OPTIONS="user="$PAM_USER",uid=$(id -u "$PAM_USER"),gid=$(id -g "$PAM_USER"),sec=krb5i,cruid=$(id -u "$PAM_USER"),nodev,nosuid,vers=3.1.1"
LOGFILE="$HOME/mount.log"

# Fonctions 
log() { printf "[%s] %s\n" "$(date '+%T')" "$*"; } >> "$LOGFILE"

# MAIN 
log "=== SCRIPT MONTAGE LINUX (user: $PAM_USER) ==="

for entry in "${PARTAGES[@]}"; do
	log "Recherche montage pour '$entry'..."
	IFS=':' read  partage mnt groupes <<<"$entry"
	IFS=',' read -a liste_groupes <<<"$groupes"
	remote="//$SERVEUR/$partage"
	for g in "${liste_groupes[@]}"; do
		if id -nG "$PAM_USER" | grep -qw "$g"; then
			log "UTILISATEUR $PAM_USER MATCH GROUPE $g"
			[[ -d "$mnt" ]] || (mkdir -p "$mnt"; log "Crée: $mnt")

			if mountpoint -q "$mnt"; then
			    log "$mnt déjà monté"
  			else
    			    log "Montage $remote -> $mnt"
			   sudo /sbin/mount.cifs "$remote" "$mnt" -o "$OPTIONS" >> "$HOME/error.mount.log" 2>&1 &
 			fi
			continue 2
		fi
	done
	log "Aucun groupe trouvé pour ce partage"
done

log "=== Fin SCRIPT MONTAGE LINUX ==="
