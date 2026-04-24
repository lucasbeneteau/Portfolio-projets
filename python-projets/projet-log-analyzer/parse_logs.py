import re
import sys
from pathlib import Path
from collections import defaultdict

def analyser_logs(chemin_fichier):

    ips = defaultdict(int)
    status = defaultdict(int)
    ips_status = defaultdict(lambda: defaultdict(int))
    
    regex_log = r"^(\d+\.\d+\.\d+\.\d+).*1\.1\" (\d{3}) .*"
    
    fichier_log = Path(chemin_fichier)
    
    if not fichier_log.exists():
        print(f"Erreur : Le fichier {chemin_fichier} est introuvable.")
        return

    contenu = fichier_log.read_text(encoding="utf-8")
    nbLignes = len(contenu.splitlines())
    print(f"Il y a {nbLignes} requetes")

    # Parsing
    for occurence in re.finditer(regex_log, contenu, re.MULTILINE):
        ip = occurence.group(1)
        status_code = occurence.group(2)
        ips[ip] += 1
        status[status_code] += 1
        ips_status[ip][status_code] += 1

    # Analyse des IPs suspectes
    ips_suspectes = []
    for ip, codes in ips_status.items():
        nb_erreurs = sum(nb for code, nb in codes.items() if code.startswith(('4','5')))
        if nb_erreurs >= 2:
            ips_suspectes.append((ip, nb_erreurs))
    print(f"Liste des ips ayant plus de 2 échecs de connection {ips_suspectes}")

    # IPs les plus actives
    ips_actives = sorted(ips, key=ips.get, reverse=True)[:2]
    print(f"Les deux ips les plus actives sont {ips_actives}")

    # Calcul du pourcentage d'erreur
    total_success = sum(nb for code, nb in status.items() if code.startswith('2'))
    pourcentage_erreur = ((nbLignes - total_success) / nbLignes) * 100
    print(f"Le pourcentage d'erreur global est de {pourcentage_erreur} %")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        chemin = sys.argv[1]
    else:
        print("Veuillez spécifier le chemin du fichier à analyser.")
        sys.exit(1)
        
    analyser_logs(chemin)