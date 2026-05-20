# Infrastructure Virtualisée (Proxmox VE)

## Présentation du Projet
Réalisation d'une infrastructure complète sur Proxmox VE avec **segmentation réseau (NAT,VLAN)** et **durcissement Firewall**.

---

## Stack Technique
* **Hyperviseur** : Proxmox VE 9.1.
* **Réseau** : Linux Bridge (VLAN Aware), Routage L3, NAT/DNAT.
* **Sécurité** : PVE Firewall (IPSet, Security Groups).

---

## Architecture & Réalisations

### 1. Segmentation Réseau & Isolation
* **NAT MASQUERADING** : Configuration en réseaux privés
* **VLAN 10 (Production/Services)** : Isolation des machines clientes et des services applicatifs.
* **VLAN 20 (Storage)** : Zone isolée dédiée au stockage (NAS).

### 3. Sécurisation des Accès (Hardening)
* **Filtrage** : Seuls les flux necéssaires sont autorisés via des règles de pare-feu.
* **IPSet** : Listes d'IP dynamiques.

## Compétences acquises
* **Design d'architecture réseau virtuelle** et segmentation complexe L2/L3.
* **Hardening système et réseau** (Firewalling, principe du moindre privilège).
* **Virtualisation** (KVM et LXC).
