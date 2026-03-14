# Projet 09 — Hardening & Sécurisation de services Web

## Objectif
Mettre en place un **serveur web sécurisé** afin de protéger les services contre les attaques réseau et applicatives.

## Architecture

L'infrastructure comprend :

- un **serveur web Apache / Nginx**
- des services sécurisés **HTTPS et FTPS**
- un **pare-feu avec NFTables**
- des outils de protection contre les attaques

## Mesures de sécurité mises en place

- Activation de **HTTPS (TLS)** pour sécuriser les flux web
- Mise en place de **FTPS** avec chroot
- Configuration du **pare-feu NFTables**
- Protection contre les attaques avec **Fail2ban**
- Application de bonnes pratiques **OWASP**
- **mod_evasive** : protection contre les attaques **DDoS et flood HTTP**
- **mod_reqtimeout** : protection contre les attaques **Slow HTTP**
- limitation du nombre de connexions
- filtrage des requêtes suspectes

## Étapes de réalisation

- Installation et configuration de **Nginx et Apache**
- Configuration du **HTTPS**
- Mise en place de **FTPS**
- Configuration du **pare-feu NFTables**
- Installation et configuration de **Fail2ban**
- Activation des protections **anti-DDoS et anti Slow Connection**
- Tests de sécurité et validation du fonctionnement

## Stack technique

- **Linux**
- **Nginx**
- **Apache**
- **NFTables**
- **Fail2ban**
- **HTTPS / TLS**
- **FTPS**
- **OWASP**
