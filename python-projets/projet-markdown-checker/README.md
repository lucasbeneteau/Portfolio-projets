# Documentation du script

Ce script parcourt récursivement les répertoires pour s'assurer que tous les liens locaux cités dans les fichiers `.md` pointent vers des fichiers existants.

## Utilisation

* **Commande :** `python3 check_links.py [chemin_cible]`
* **Note :** Si aucun chemin n'est spécifié, le script analyse le dossier courant.

## Fonctionnement

* **Scan récursif :** Analyse tous les fichiers `.md` de l'arborescence (en ignorant `.git` et `venv`).
* Supporte les liens relatifs (`./` ou `../`) et les liens racines (`/`).
* Affiche fichier source, numéro de la ligne et chemin complet du lien cassé.
