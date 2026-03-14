# Projet 04 — Automatisation Active Directory & Gestion du parc

## Objectif
- Automatiser le déploiement d'un environnement **Active Directory** ainsi que la gestion du **parc informatique**.
- Automatiser le déploiement de mises à jour et de logiciels (linux et windows) à l'aide d'Ansible.
- Automatiser le montage des partages réseau selon l'utilisateur,sa hiérarchie, son groupe associé (Bash / PowerShell).

## Étapes de réalisation

- Script **PowerShell** pour automatiser sur le serveur AD :
  - l'installation et la configuration d'**Active Directory**
  - la création des **OU**
  - l'import des **utilisateurs et groupes depuis un fichier CSV**
  - Création de **partages réseau** avec les bonnes autorisations selon la méthode **AGDLP**

- Scripts de **montage automatique des partages** :
  - PowerShell pour les postes Windows
  - Bash pour les postes Linux

- Utilisation de **Ansible** pour :
  - déployer les **mises à jour**
  - installer des **logiciels**
    - Kontrast (Linux)
    - Colour Contrast Analyzer – CCA (Windows)

- Import du **parc informatique dans GLPI** via plugin d’inventaire depuis fichier csv
---

## Stack technique

- **Windows Server / Active Directory**
- **PowerShell/Bash**
- **Ansible**
- **Linux**
- **GLPI**
- **CSV**
- **Excel**
