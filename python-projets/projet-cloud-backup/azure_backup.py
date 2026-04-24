import os
import sys
import zipfile
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobClient
from azure.core.exceptions import AzureError

# Chargement des variables .env
load_dotenv()

def compresser(dossier, archive_path):
    if not dossier.exists():
        print(f"Erreur : Le dossier {dossier} est introuvable.")
        return False

    with zipfile.ZipFile(archive_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        if dossier.is_file():
            zipf.write(dossier, dossier.name)
        else:
            for element in dossier.rglob("*"):
                if element.is_file():
                    zipf.write(element, element.relative_to(dossier))
    
    print(f"Archive créée : {archive_path.name} ({archive_path.stat().st_size} octets)")
    return True

def upload_blob(archive_path):
    account_name = os.getenv("AZURE_STORAGE_ACCOUNT")
    container_name = os.getenv("AZURE_CONTAINER_NAME")
    
    if not account_name or not container_name:
        print("Erreur : Variables d'environnement AZURE_STORAGE_ACCOUNT ou CONTAINER_NAME manquantes.")
        return

    blob_url = f"https://{account_name}.blob.core.windows.net/{container_name}/{archive_path.name}"
    credential = DefaultAzureCredential()

    try:
        blob_client = BlobClient.from_blob_url(blob_url, credential=credential)
        with open(archive_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)
        print(f"Backup terminé avec succès sur Azure")
        
    except AzureError as e:
        print(f"Erreur lors de l'upload Azure : {e}")
    except Exception as e:
        print(f"Une erreur inattendue est survenue : {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        dossier_source = Path(sys.argv[1])
    else:
        print("Veuillez spécifier le chemin du dossier.")
        sys.exit(1)

    timestamp = datetime.now().strftime("%Y%m%d_%H")
    archive_path = dossier_source.with_name(f"archive_log_{timestamp}.zip")

    if compresser(dossier_source, archive_path):
        upload_blob(archive_path)
        if archive_path.exists():
            archive_path.unlink()
            print(f"Nettoyage : Archive locale supprimée.")