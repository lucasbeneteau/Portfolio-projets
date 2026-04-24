# Documentation du script

Ce script analyse un fichier de log serveur (type `access.log`) pour extraire des statistiques sur les adresses IP, les codes de statut HTTP et détecter des comportements suspects.

## Utilisation

* **Commande :** `python3 parse_logs.py [chemin_du_fichier.log]`

## Fonctionnement

* Compte le nombre total de requêtes et identifie les deux adresses IP les plus actives.
* Identifie et liste les adresses IP ayant échoué à se connecter plus de 2 fois (codes d'erreur 4xx ou 5xx).
* Calcule le pourcentage d'erreur sur l'ensemble du fichier.