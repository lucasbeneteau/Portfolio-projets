# Documentation du script Cloud Backup

Ce script automatise la compression d'un dossier ou d'un fichier de logs et son transfert sécurisé vers un stockage Cloud Azure Blob Storage.

## Utilisation

* **Commande :** `python3 cloud_backup.py [chemin_source]`

## Fonctionnement

* Crée une archive compressée horodatée (`YYYYMMDD_HHMM`).
* Utilise `DefaultAzureCredential` pour une connexion sécurisée via les variables d'environnement.
* Téléverse l'archive vers le conteneur Azure spécifié dans le fichier `.env`.
* Supprime l'archive locale après un transfert réussi.

## Prérequis

* **Python 3.8**
* **Dépendances** : `azure-storage-blob`, `azure-identity`, `python-dotenv`.
* **Configuration** : Un fichier `.env` contenant les identifiants Azure.