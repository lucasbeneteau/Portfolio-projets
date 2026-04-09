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
* main.bicep :Point d'entrée unique (Orchestrateur)
* Network : Déploiement du réseau
* Compute : Déploiement des machines virtuelles, interfaces réseau, loadbalancer.

## Stack technique

- Microsoft Azure
- Azure Virtual Machines
- Azure Virtual Network
- Azure Entra ID
- RBAC
- Bicep
