# Projet 01 — Infrastructure Active Directory Multi-sites

## Objectif
Concevoir une **architecture d'identité centralisée et sécurisée** pour une entreprise disposant :

- d'un **siège (site principal)**
- d'une **agence distante**

## Architecture du projet

L'environnement simule une entreprise avec :

- un **contrôleur de domaine principal (DC)** sur le site principal
- un **contrôleur de domaine en lecture seule (RODC)** sur le site distant
- un **tunnel VPN IPsec site-à-site**


## Schéma réseau
<img width="675" height="509" alt="image" src="https://github.com/user-attachments/assets/33ed9285-bd38-4c29-901f-f89f037ada1d" />


---

# Étapes de réalisation

### 1 — Mise en place du contrôleur de domaine

- Installation de **Windows Server 2019**
- Installation du rôle **Active Directory Domain Services**
- Promotion du serveur en **contrôleur de domaine**
- Création des :
- **OU**
- **utilisateurs**
- **groupes**

---

### 2 — Mise en place du VPN site-à-site

Configuration d'un **tunnel VPN IPsec entre les deux sites** avec **pfSense** :

- configuration **Phase 1**
- configuration **Phase 2**
- définition des réseaux locaux
- tests de connectivité entre les sites

---

### 3 — Déploiement de GPO

Création et application de **Group Policy Objects** :

- interdiction de travailler entre 20h et 6h
- disques amovibles non autorisés, sauf pour le service IT
- L’outil f.lux doit être déployé sur le poste de Ana Garcia du site de Nantes.

---

### 4 — Installation du RODC sur le site distant

Déploiement d'un **Read-Only Domain Controller** dans l'agence distante :

- promotion du serveur en **RODC**
- configuration de la **Password Replication Policy**
- authentification locale des utilisateurs

---

# Stack technique
- **Windows Server**
- **Windows 10**
- **PfSense**
- **PowerShell**
