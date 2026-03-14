# Projet 07 — Simulation réseau Cisco

## Objectif
Concevoir et simuler une infrastructure réseau d'entreprise sous **Cisco Packet Tracer** intégrant segmentation réseau, routage dynamique, redondance et sécurité.

## Architecture réseau

L'infrastructure comprend :

- plusieurs **VLAN métiers** (Direction, RH, Commercial, Finance, IT…)
- des **switchs d'accès et de distribution**
- un **switch Core Layer 3**
- plusieurs **routeurs**
- un **serveur Web et un serveur DNS**

Fonctionnalités implémentées :

- segmentation réseau avec **VLAN**
- routage **inter-VLAN**
- routage dynamique avec **OSPF**
- redondance de passerelle avec **HSRP**
- **Load balancing avec LACP**
- protection contre les boucles avec **STP**
- accès Internet via **NAT**
- sécurisation du réseau avec **ACL**

## Schéma réseau

![Architecture réseau](schema_reseau.png)


## Étapes de réalisation

- Création et configuration des **VLAN**
- Configuration du **routage inter-VLAN**
- Mise en place du **routage dynamique OSPF**
- Configuration de la **redondance HSRP**
- Mise en place de **LACP pour l’agrégation de liens**
- Configuration du **Spanning Tree Protocol (STP)**
- Mise en place du **NAT pour l'accès Internet**
- Création des **ACL pour contrôler les accès**
- Tests de connectivité entre les VLAN et les serveurs

## Stack technique

- **Cisco Packet Tracer**
- **VLAN**
- **OSPF**
- **HSRP**
- **LACP**
- **STP**
- **NAT**
- **ACL**
- **IPv4 / IPv6**
