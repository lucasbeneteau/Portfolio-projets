# Infrastructure Virtualisée et Sauvegarde (Proxmox VE)

## Présentation du Projet
Réalisation d'une infrastructure complète sur Proxmox VE simulant un environnement d'entreprise. L'accent est mis sur la **segmentation réseau**, le **durcissement sécuritaire** et une stratégie de **sauvegarde hybride (3-2-1)** incluant un déport vers le Cloud Azure.

---

## Stack Technique
* **Hyperviseur** : Proxmox VE 9.1.
* **Réseau** : Linux Bridge (VLAN Aware), Routage L3, NAT/DNAT.
* **Sécurité** : PVE Firewall (IPSet, Security Groups), VPN WireGuard.
* **Stockage & Sauvegarde** : Proxmox Backup Server (PBS), NAS (OpenMediaVault).
* **Cloud** : Azure Blob Storage, Rclone (Automation Bash via Service Principal).

---

## Architecture & Réalisations


### 1. Segmentation Réseau & Isolation (VLAN)
* **NAT MASQUERADING** : Configuration en réseaux privés
* **VLAN 10 (Production/Services)** : Isolation des machines clientes et des services applicatifs.
* **VLAN 20 (Storage)** : Zone isolée dédiée au stockage (NAS), sans accès direct à Internet pour prévenir l'exfiltration de données.

### 3. Sécurisation des Accès (Hardening)
* **Filtrage** : Seuls les flux necéssaires sont autorisés via des règles de pare-feu restrictives.
* **VPN WireGuard** : Déploiement d'une passerelle VPN pour un accès distant sécurisé aux interfaces de gestion et au RDP/SSH.
* **IPSet** : Utilisation de listes d'IP dynamiques pour simplifier et renforcer la gestion des règles de filtrage.

### 4. Stratégie de Sauvegarde (Règle 3-2-1)
Mise en place d'une politique de sauvegarde journalière:

* **Continuité immédiate (Hôte Proxmox)** - Utilisation de **Snapshots** manuels avant chaque modification technique importante.
* **Sauvegarde LAN** : Automatisation de sauvegardes incrémentales journalieres vers le NAS via SMB.
* **Externalisation Cloud (Azure)** : Sauvegarde automatique des archives critiques vers un container **Azure Blob Storage** via Rclone et Service Principal.
* **Tests de Restauration**.
---

## Compétences acquises
* **Design d'architecture réseau virtuelle** et segmentation complexe L2/L3.
* **Hardening système et réseau** (Firewalling étendu, VPN, principe du moindre privilège).
* **Stratégie de sauvegarde, résilience et restauration**.
* **Virtualisation** (KVM et LXC).