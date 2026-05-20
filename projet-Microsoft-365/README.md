# Administration Microsoft 365

## Présentation du Projet
Projet personnel réalisé dans le but de prendre en main et de maîtriser les différents produits de l'écosystème **Microsoft 365 (Entra, Azure, Intune, Exchange, SharePoint)**.<br>
L'objectif principal est d'être directement opérationnel sur ces technologies en qualité de **support** et **d'infogérance informatique**.

## Stack Technique
* Microsoft Entra ID.
* Microsoft Intune.
* Exchange Online & Microsoft Defender.
* SharePoint Online & OneDrive.
* Microsoft Azure.

## Architecture & Réalisations

### 1. Gestion des Identités et Ressources Azure (Entra ID/Azure)
* **Gestion Utilisateurs et Groupes :** Création, modification et suppression (comptes internes, invités, groupes).
* **Contrôle d'Accès & RBAC :** Attribution des rôles d'administration (principes du moindre privilège) et gestion RBAC des ressources Azure.
* **Sécurisation des Accès :** Configuration MFA, méthodes d'authentification et politiques d'accès conditionnel.
* **Licensing :** Attribution des licences par utilisateur ou par groupe.
* **Déploiement Azure :** Création et gestion de ressources de base (VMs, stockage, réseaux virtuels).

### 2. Gestion du parc via Microsoft Intune
* **Déploiement Autopilot :** Configuration profils déploiement et ESP.
* **Configuration politique de sécurité :** Windows hello for business, LAPS, groupes locaux.
* **MDM / Sécurisation des postes :** Configuration Security Baselines, templates de restriction, firewall et autre.
* **Applications :** Packaging et déploiement d'applications Win32 et Microsoft Store.
* **Mises à jour :** Configuration Update Rings Windows.

### 3. Exchange & Defender
* **Récipients :** Gestion des boîtes (utilisateurs, partagées, salles), listes d'adresses (GAL, OAB, ABP) et groupes de distribution.
* **Flux Mail & Sécurité :** Implémentation SPF, DKIM, DMARC et règles de transport.
* **Protection Defender :** Configuration des stratégies anti-spam, anti-phishing, anti-malware et politiques d'alerte.
* **Troubleshooting :** Analyse de headers, Message Trace et Connectivity Analyzer.
* **Quota & Rétention :** Configuration des limites de stockage, archivage et stratégies de rétention des boîtes aux lettres.

### 4. SharePoint (En cours)
* **Structure :** Architecture de sites (Hub, Team, Communication) et bibliothèques de documents.
* **Permissions :** Gestion des partages (interne/externe) et restrictions d'accès.
* **Gestion Documentaire :** Configuration du versionning, check-in/out et restauration.
