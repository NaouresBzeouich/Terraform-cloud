*Titre du TP : Déploiement d’une image Docker via un Pipeline CI/CD avec Jenkins, Terraform et Ansible*


*Objectif :*

Ce TP a pour objectif de vous permettre de configurer un pipeline CI/CD complet pour déployer une application conteneurisée via Docker, en utilisant Terraform pour provisionner l’infrastructure et Ansible pour automatiser la configuration et l’installation sur les serveurs. L'accent sera mis sur l’idempotence dans Ansible.


---


*Partie 1 : Provisionner l'infrastructure avec Terraform*


*Objectifs spécifiques :*
Créer un fichier de configuration Terraform pour provisionner une infrastructure (par exemple, une instance EC2 sur AWS ou une VM sur un cloud privé comme GCP ou Azure).
Utiliser Terraform pour automatiser le processus de création d'infrastructure (machines virtuelles, réseaux, groupes de sécurité, etc.).
Intégrer ce processus dans un pipeline Jenkins pour qu'il soit exécuté à chaque déploiement.

*Étapes :*



1. *Installer Terraform sur la machine de Jenkins* :

Télécharge et installe Terraform sur le serveur Jenkins ou la machine utilisée pour exécuter le pipeline.

2. *Créer un fichier de configuration Terraform* :

Dans ce fichier, tu dois définir les ressources nécessaires, telles qu'une machine virtuelle (par exemple une instance EC2 dans AWS) et les paramètres associés (nom de l'instance, type de machine, etc.).
Exemple : Provisionner une instance EC2 sur AWS avec Terraform.


```hcl

provider "aws" {

region = "us-east-1"

}


resource "aws_instance" "web" {

ami = "ami-0c55b159cbfafe1f0" # Exemple d'AMI (adapté à votre region)

instance_type = "t2.micro"


tags = {

Name = "DevOps-Instance"

}

}

```


3. *Initialiser et appliquer la configuration Terraform* :

Exécute `terraform init` pour initialiser le projet.
Exécute `terraform apply` pour provisionner les ressources sur le cloud.


Exécute `terraform stop` pour libérer les ressources sur le cloud.

4. *Intégrer Terraform dans le pipeline Jenkins* :

Crée un pipeline Jenkins qui exécute les étapes Terraform automatiquement : initialiser, planifier et appliquer les configurations.
Exemple de script Jenkinsfile pour intégrer Terraform :


```groovy

pipeline {

agent any

stages {

stage('Terraform Init') {

steps {

sh 'terraform init'

}

}

stage('Terraform Plan') {

steps {

sh 'terraform plan'

}

}

stage('Terraform Apply') {

steps {

sh 'terraform apply -auto-approve'

}

}

}

}

```


5. *Tester la création de l’infrastructure* :

Une fois que Terraform a exécuté les commandes, vérifie dans le cloud que l’infrastructure a été correctement déployée (par exemple, une nouvelle instance EC2 devrait apparaître dans AWS).

---


*Partie 2 : Automatiser le déploiement de l’image Docker avec Ansible (Principe d'idempotence)*


*Objectifs spécifiques :*
Créer un playbook Ansible pour configurer la machine virtuelle provisionnée (installation de Docker, configuration du serveur, etc.).
Appliquer le principe d'idempotence dans les tâches Ansible pour s'assurer qu'elles peuvent être exécutées plusieurs fois sans provoquer d'effets secondaires.
Déployer l’image Docker de l’application sur l'instance provisionnée.

*Étapes :*


1. *Installer Ansible sur la machine de Jenkins* :
Assure-toi qu'Ansible est installé sur la machine Jenkins. Tu peux utiliser `pip` pour installer Ansible :
```bash

pip install ansible

```


2. *Créer un fichier d'inventaire Ansible* :

Ce fichier doit contenir l'adresse IP de l'instance EC2 créée par Terraform.
Exemple de fichier `inventory.ini` :


```ini

[web]

54.234.123.45 # Adresse IP de l'instance EC2

```


3. *Écrire un playbook Ansible pour déployer l’image Docker* :

Le playbook Ansible doit installer Docker sur la machine cible, télécharger l’image Docker et démarrer le conteneur.
Exemple de playbook Ansible pour installer Docker et déployer une image :


```yaml

---

name: Déployer l'image Docker sur l'instance EC2
hosts: web

become: true

tasks:

name: Installer Docker
apt:

name: docker.io

state: present

tags: docker


name: Lancer le conteneur Docker
docker_container:

name: myapp

image: myapp:latest

state: started

restart_policy: always

tags: docker

```
Ce playbook garantit que Docker est installé et que l'image est lancée sur l'instance. Le principe d’idempotence est respecté, car l'image sera installée et lancée seulement si ce n'est pas déjà fait.

4. *Exécuter le playbook Ansible via Jenkins* :

Crée une étape dans le pipeline Jenkins pour exécuter ce playbook Ansible une fois que l'infrastructure est provisionnée par Terraform.
Exemple d'ajout dans le Jenkinsfile :


```groovy

pipeline {

agent any

stages {

stage('Terraform Init') {

steps {

sh 'terraform init'

}

}

stage('Terraform Plan') {

steps {

sh 'terraform plan'

}

}

stage('Terraform Apply') {

steps {

sh 'terraform apply -auto-approve'

}

}

stage('Deploy with Ansible') {

steps {

sh 'ansible-playbook -i inventory.ini playbook.yml'

}

}

}

}

```


5. *Tester le déploiement* :

Une fois que le pipeline Jenkins est exécuté, vérifie sur l'instance que Docker est installé et que l’image Docker de l’application est bien déployée.

---

*Évaluation et Critères de Réussite :*

1. *Provisionnement d’infrastructure avec Terraform* :

La machine virtuelle ou instance cloud doit être correctement provisionnée et accessible via SSH.
2. *Automatisation avec Ansible* :

Docker doit être installé sur l’instance cible.
L’image Docker doit être déployée et le conteneur doit être en état "exécuté" sur l'instance.
Le principe d’idempotence doit être respecté : plusieurs exécutions du playbook ne doivent pas entraîner de comportements indésirables.
3. *Pipeline CI/CD complet avec Jenkins* :

Le pipeline doit s’exécuter correctement sans erreur, avec chaque étape automatisée (Terraform, Ansible).
4. *Tests fonctionnels* :

Vérifier si l'application dans le conteneur fonctionne comme prévu (ex. via une connexion HTTP si l’application expose un port).

---


*Conclusion :*

A l'issue de ce TP, vous aurez acquis une expérience pratique sur l'intégration de Terraform et Ansible dans un pipeline CI/CD avec Jenkins. Vous aurez compris l'importance de l’idempotence dans l’automatisation des déploiements et serez capables de déployer une application conteneurisée dans un environnement cloud de manière automatisée et reproductible.