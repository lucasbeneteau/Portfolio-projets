# Projet 12 — Administration Cloud Azure 

## Objectif
Déployer et administrer une infrastructure **Microsoft Azure** en appliquant les bonnes pratiques de gestion des ressources, du réseau et de la sécurité.

Projet réalisé dans le cadre de la préparation à la certification **AZ-104 : Azure Administrator**.

## Architecture

Infrastructure Azure comprenant :
- **Virtual Network (VNet) et sous-réseaux**
- **Peering**
- **Network Security Groups (NSG)**
- **LoadBalancer**
- **Azure Bastion**
- **Azure NatGateway**
- **Azure Firewall** et **routeTable**
- **Machines virtuelles Azure**

## Étapes réalisées
- Gestion des **identités et accès avec Entra ID et RBAC**
- Création de **Resource Groups**
- Déploiement du **réseau Azure (VNet, Subnets, NSG, Peering,Firewall,routeTable)**
- Déploiement **machines virtuelles, interfaces réseau, loadbalancer**
- Supervision des ressources

Prochaine étape : Déploiement du Stockage et Azure Backup.

## Infrastructure as Code

Automatisation du déploiement de ressources Azure avec **Bicep**

Le déploiement est structuré de manière modulaire pour favoriser la réutilisation du code et la clarté de l'infrastructure :
* [main.bicep](./Bicep/main/main.bicep): Point d'entrée unique (Orchestrateur) 
  * [network.bicep](./Bicep/main/module.main/network/network.bicep) Orchestrateur réseau
    * [modules network](./Bicep/main/module.main/network/module.network): Déploiement du réseau
  * [compute.bicep](./Bicep/main/module.main/compute/compute.bicep) Orchestrateur compute
    * [modules compute](./Bicep/main/module.main/compute/module.compute): Déploiement des machines virtuelles, interfaces réseau, loadbalancer.

## Stack technique

- Microsoft Azure
- Azure Virtual Machines
- Azure Virtual Network
- Azure Entra ID
- RBAC
- Bicep
