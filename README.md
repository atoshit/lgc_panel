# Logic Panel

Un panel d'administration moderne et intuitif pour FiveM.

## 🌟 Caractéristiques

- Interface utilisateur moderne et responsive
- Système de permissions avancé
- Gestion des rôles dynamique
- Synchronisation en temps réel
- Protection contre les manipulations non autorisées

## 📋 Prérequis

- FiveM Server
- MySQL
- oxmysql

## 💾 Installation

1. Installer la ressource dans votre dossier `resources`
2. Builder le projet avec les commandes suivantes :
    ```bash
    npm install
    npm run build
    ```
3. Ajouter `ensure lgc_panel` dans votre `server.cfg`
4. La base de données sera automatiquement configurée au démarrage

## 🔧 Configuration

### Commandes Console

- `rank <id/license> <role>` : Attribue un rôle à un joueur
  ```lua
  rank 1 admin  -- Attribue le rôle admin au joueur avec l'ID 1
  rank license:xxx mod  -- Attribue le rôle mod au joueur avec cette license
  ```

- `unrank <id/license>` : Retire le rôle d'un joueur
  ```lua
  unrank 1  -- Retire le rôle du joueur avec l'ID 1
  unrank license:xxx  -- Retire le rôle du joueur avec cette license
  ```

- `roles` : Liste tous les rôles disponibles

### Classes

#### PermissionManager

- `createRole(name, label, permissions, creatorName, creatorLicense)` : Crée un nouveau rôle
- `updateRolePermissions(name, permissions)` : Met à jour les permissions d'un rôle
- `assignRole(identifier, roleName)` : Attribue un rôle à un utilisateur
- `removeRole(identifier)` : Retire un rôle à un utilisateur
- `hasPermission(identifier, permission)` : Vérifie si un utilisateur a une permission

### Permissions Disponibles

- `panel.access` : Accès au panel
- `panel.players.view` : Voir les joueurs
- `panel.players.kick` : Expulser les joueurs
- `panel.players.ban` : Bannir les joueurs
- `panel.reports.view` : Voir les reports
- `panel.reports.manage` : Gérer les reports
- `panel.roles.manage` : Gérer les rôles

### Événements

#### Client

- Événements entrants
  - `lgc_panel:playerInfoCallback` : Reçoit les informations du joueur
  - `lgc_panel:accessCallback` : Vérifie l'accès au panel
  - `lgc_panel:forceClose` : Force la fermeture du panel
  - `lgc_panel:reloadRoles` : Recharge la liste des rôles
- Événements sortants
  - `lgc_panel:getPlayerInfo` : Demande les informations du joueur
  - `lgc_panel:checkAccess` : Vérifie les permissions

#### Server

- Événements entrants
  - `lgc_panel:getPlayerInfo` : Demande d'informations joueur
  - `lgc_panel:createRole` : Création d'un rôle
  - `lgc_panel:deleteRole` : Suppression d'un rôle
  - `lgc_panel:checkAccess` : Vérification d'accès
- Événements sortants
  - `lgc_panel:playerInfoCallback` : Envoi des informations joueur
  - `lgc_panel:accessCallback` : Réponse de vérification d'accès
  - `lgc_panel:reloadRoles` : Notification de rechargement des rôles

### Structure de la Base de Données

#### Table `lgc_roles`

- `id` : Identifiant unique du rôle
- `name` : Nom du rôle
- `label` : Label du rôle
- `permissions` : Permissions associées au rôle
- `created_by_name` : Nom de l'utilisateur qui a créé le rôle
- `created_by_license` : License de l'utilisateur qui a créé le rôle

#### Table `lgc_user_roles`

- `identifier` : Identifiant unique de l'utilisateur
- `role` : Rôle associé à l'utilisateur

## 🔒 Sécurité

- Protection du rôle administrateur
- Vérification des permissions côté serveur
- Synchronisation sécurisée des données
- Validation des entrées utilisateur

## 🎨 Interface Utilisateur

- Design moderne avec Tailwind CSS
- Animations fluides avec Framer Motion
- Interface responsive et intuitive
- Thème sombre professionnel

## ⚡ Optimisations

- Système de cache pour les performances
- Chargement asynchrone des données
- Mise à jour en temps réel
- Gestion efficace des ressources

## 🛠 Développement

Pour contribuer au projet :
1. Fork le repository
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Créer une Pull Request

## 📝 License

Copyright © 2025 Logic. Studios


