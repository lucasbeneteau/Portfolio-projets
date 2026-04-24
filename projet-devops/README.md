# Automation Cloud & CI/CD

## Présentation du Projet
L'objectif était de monter en compétences sur les problématiques de **Cloud** et de **DevOps** en automatisant le cycle de vie complet d'une infrastructure sur Azure.

Il repose sur le principe de **l'infrastructure immuable** : aucun serveur n'est configuré à la main, tout est piloté par le code.

---

## Stack technique
* **Cloud :** Microsoft Azure (VNet, VM, ACR, NAT Gateway, keyvault)
* **Infrastructure as Code (IaC) :** [Bicep](./bicep/)
* **Gestion de Configuration (CaC) :** [Ansible](./ansible/deploy.yml)
* **CI/CD :** [GitLab CI](./.gitlab-ci.yml)
* **Conteneurisation :** [Docker](./docker/Dockerfile)
* **Sécurité :** Azure RBAC & Conditions ABAC (Attribute-Based Access Control)

---

## Architecture Technique

### 1. Infrastructure as Code (Bicep)
Développement d'une infrastructure dynamique et automatisée contenant entre autres:
* **Modularité** : Découpage du code en [modules](./bicep/modules/) réutilisables (Réseau, Sécurité, Calcul) pour une maintenance facilitée.
* **Standardisation** : Automatisation du nommage des ressources et des profils de machines (Web/DB) pour garantir la cohérence des déploiements.
* **Architecture pilotée par les données** : Utilisation de boucles et de fonctions avancées (`toObject`, `items`) pour générer automatiquement les ressources à partir d'un fichier de paramètres.
* **Réseau & Sécurité** : Segmentation par sous-réseaux, isolation via NSG et sécurisation des flux sortants par NAT Gateway.

### 2. Automatisation & Déploiement (Ansible)
Le [playbook](./ansible/deploy.yml) assure la mise en service applicative complète dès le premier boot :
* **Provisionnement Docker** : Installation automatisée du moteur et des dépendances.
* **Sécurité Identity-Based** : Authentification via l'Identité Managée Azure éliminant l'usage de mots de passe ou de tokens.
* **Intégration ACR** : Connexion sécurisée au registre privé, pull de l'image et cycle de déploiement (`Stop` / `Update` / `Run`).

### 3. Pipeline CI/CD ([GitLab](./.gitlab-ci.yml))
Automatisation complète:
* **Image de build personnalisée** : Création d'une [image Docker](./image-runner-gitlab/Dockerfile) optimisée à l'usage du runner.
* **Validation & Preview** : Linting Bicep et prévisualisation des changements.
* **IaC** : Déploiement automatique des ressources Azure.
* **Supply Chain Docker** : Build et Push des images sur l'ACR privé Azure.
* **Orchestration Ansible** : Déploiement applicatif automatisé sur la VM
.
---

### 4. Focus Sécurité : Architecture "Zero Trust"
Le projet implémente les principes du moindre privilège pour sécuriser la chaîne de déploiement :
* **Déploiement Piloté par SP** : Utilisation d'un Service Principal dédié au provisionnement de l'infrastructure et à l'assignation des rôles.
* **Sécurité des Secrets** : Récupération dynamique de la clé SSH privée depuis **Azure Key Vault** lors du déploiement.
* **Gouvernance ABAC** : Restriction des pouvoirs du service-principal via des conditions ABAC (Attribute-Based Access Control), limitant strictement les types de rôles qu'il peut distribuer.
* **Identités Managées (MSI)** : Les VMs utilisent leurs propres identités Azure pour s'authentifier.
* **Secretless Pull** : Récupération des images Docker via `az login --identity`, éliminant le besoin de stocker des identifiants ou des tokens sur les instances.

---

## Compétences acquises
* **Design d'architecture Cloud** évolutive et sécurisée.
* **Infrastructure as Code**.
* **Automatisation des déploiements** via pipeline CI/CD.
* **Gestion des identités et des accès**.

---

## Conclusion
Ce projet m'a permis de découvrir le DevOps et je souhaiterais aller plus loin, notamment en utilisant **Docker Compose**, en apprenant **Kubernetes** ou encore utiliser **Terraform** plutôt que Bicep.

On pourrait améliorer ce projet dès maintenant de plusieurs manières notamment :
* Utiliser deux services principal distincts : un pour créer les ressources et un autre pour gérer les accès (RBAC).
* Évoluer vers **Docker Compose** pour gérer plusieurs services, ou **Azure Container Apps**.
* Centraliser les logs et les métriques sur un dashboard **Azure Monitor**.