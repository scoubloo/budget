# Budget

## Installation du projet

### Pré requis

- Télécharger Docker sur https://www.docker.com/
- Git

### Construction des containers docker
```shell
~ make docker-build
```

### Construction des containers docker
```shell
~ make docker-up
```

### Accès aux applications
Modifier le fichier /etc/hosts et ajouter la ligne suivante
```shell
[...]
127.0.0.1   local.budget
[...]
```

## Url des app

- local.budget