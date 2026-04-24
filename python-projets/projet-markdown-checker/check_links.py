import re
import sys
from pathlib import Path

REGEX_LIEN = re.compile(r"\]\(([^)#\s]+)\)")

def check_my_links(target_path):
    folder_to_scan = Path(target_path).resolve() 

    if not folder_to_scan.exists():
        print(f"Erreur : Le dossier '{folder_to_scan}' n'existe pas.")
        return
    
    print(f"Analyse des liens dans : {folder_to_scan}\n")

    count_errors = 0
    for file_path in folder_to_scan.rglob("*.md"):
        # On esquive .git et venv
        if any(part in file_path.parts for part in [".git", "venv"]):
            continue

        with open(file_path, "r", encoding="utf-8") as f:
            for num_ligne, ligne in enumerate(f, 1):
                for match in REGEX_LIEN.finditer(ligne):
                    lien = match.group(1)
                    
                    if not lien or lien.startswith(("http://", "https://")):
                        continue

                    if lien.startswith("/"):
                        # Lien racine github
                        chemin_final = folder_to_scan / lien.lstrip("/")
                    else:
                        # Lien relatif (./ , ../ , ou direct)
                        chemin_final = (file_path.parent / lien).resolve()

                    if not chemin_final.exists():
                        count_errors += 1
                        print(f"ERREUR : {file_path.relative_to(folder_to_scan)} (Ligne {num_ligne})")
                        print(f"Lien cassé : {lien}")
                        print(f"Cherché ici : {chemin_final}\n")

    print(f"Analyse terminée. {count_errors} erreur(s) détectée(s).")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        path_to_check = sys.argv[1]
    else:
        path_to_check = "."
        
    check_my_links(path_to_check)