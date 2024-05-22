# Installation d'un Serveur Docker sur Debian

Ce guide détaille les étapes pour installer Docker sur une distribution Debian. Docker est une plateforme permettant de développer, livrer et exécuter des applications dans des conteneurs. 

## Prérequis

Avant de commencer, assurez-vous que :

- Vous avez un accès root ou des privilèges sudo.
- Votre système est à jour.

## Étapes d'Installation

### 1. Mettre à Jour le Système

Avant d'installer Docker, il est recommandé de mettre à jour votre système pour vous assurer que tous les paquets sont à jour.

```sh
sudo apt-get update
sudo apt-get upgrade -y
```

### 2. Installer les Dépendances
Installez les paquets nécessaires pour permettre à apt d'utiliser des paquets via HTTPS.

```sh
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

### 3. Ajouter la Clé GPG Officielle de Docker

Ajoutez la clé GPG officielle de Docker à votre système.
```sh
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
### 4. Ajouter le Dépôt Docker

Ajoutez le dépôt Docker à votre liste de sources apt.

```sh
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
### 5. Mettre à Jour la Liste des Paquets
Mettez à jour la liste des paquets pour inclure le dépôt Docker.

```sh
sudo apt-get update
```
### 6. Installer Docker Engine
Installez Docker Engine, Docker CLI, et Docker Compose.

```sh
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

### 7. Vérifier l'Installation de Docker
Vérifiez que Docker est correctement installé et qu'il fonctionne.

```sh
sudo systemctl status docker
```
Pour vérifier la version de Docker installée :

```sh
docker --version
```
### 8. Exécuter Docker en Tant qu'Utilisateur Non-Root
Pour exécuter Docker en tant qu'utilisateur non-root, ajoutez votre utilisateur au groupe Docker.

Ajoutez le groupe Docker si ce n'est pas déjà fait.

```sh
sudo groupadd docker
```

Ajoutez votre utilisateur au groupe Docker.

```sh
sudo usermod -aG docker $USER
```
Appliquez les nouveaux groupes sans redémarrer (optionnel).

```sh
newgrp docker
```

Vérifiez que vous pouvez exécuter Docker sans sudo.

```sh
docker run hello-world
```
## Instructions pour Construire et Exécuter le Conteneur

### Construire l'Image Docker :

```sh

docker build -t terraform-container .
```

### Exécuter le Conteneur :

```sh
docker run --rm terraform-container
```
Cette commande affichera la version de Terraform pour vérifier que tout est correctement configuré.

### Utiliser le Conteneur pour Exécuter des Commandes Terraform :

Vous pouvez exécuter des commandes Terraform en utilisant ce conteneur. Par exemple, pour afficher l'aide de Terraform :

```sh
docker run --rm terraform-container help
docker run --rm -v $(pwd)/:/workspace -w /workspace terraform-container init
docker run --rm --network host -v $(pwd)/:/workspace -w /workspace terraform-container apply --auto-approve
```

## Explications

**Image de Base** : Utilise python:3.6-slim comme image de base pour inclure Python 3.6.
**Installation de Terraform** : Télécharge et installe Terraform à partir des archives officielles.
**Installation de Packer** : Télécharge et installe Packer de la même manière.
**Requirements Python** : Copie le fichier requirements.txt et installe les dépendances Python spécifiées.
**Entrypoint** : Définit Terraform comme point d'entrée du conteneur pour qu'il soit exécuté par défaut lorsque le conteneur démarre.

Ce Dockerfile vous permet de créer un environnement conteneurisé avec toutes les dépendances nécessaires pour utiliser Terraform, Packer, et les modules Python spécifiés.