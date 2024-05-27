# Configuration du cluster proxmox

Pour utiliser le module Terraform `proxmox_vm_qemu` avec Proxmox, l'utilisateur doit disposer de certains droits spécifiques afin de pouvoir créer, gérer et supprimer des machines virtuelles. Voici les droits nécessaires pour un utilisateur Proxmox afin de travailler avec le module Terraform mentionné.

### Droits Nécessaires dans Proxmox pour Utiliser le Module Terraform `proxmox_vm_qemu`

1. **VM.Audit**: Permet à l'utilisateur de lire les informations sur les machines virtuelles.
2. **VM.Config.Disk**: Permet à l'utilisateur de configurer et gérer les disques des machines virtuelles.
3. **VM.Config.CPU**: Permet à l'utilisateur de configurer les ressources CPU des machines virtuelles.
4. **VM.Config.Memory**: Permet à l'utilisateur de configurer les ressources mémoire des machines virtuelles.
5. **VM.Config.Network**: Permet à l'utilisateur de configurer les interfaces réseau des machines virtuelles.
6. **VM.Config.Options**: Permet à l'utilisateur de configurer diverses options des machines virtuelles.
7. **VM.Config.Cloudinit**: Permet à l'utilisateur de configurer les options Cloud-Init pour les machines virtuelles.
8. **VM.PowerMgmt**: Permet à l'utilisateur de démarrer, arrêter, redémarrer et suspendre les machines virtuelles.
9. **VM.Monitor**: Permet à l'utilisateur d'exécuter des commandes dans la console de la machine virtuelle.
10. **VM.Snapshot**: Permet à l'utilisateur de gérer les snapshots des machines virtuelles.
11. **VM.Clone**: Permet à l'utilisateur de cloner des machines virtuelles.
12. **Datastore.AllocateSpace**: Permet à l'utilisateur d'allouer de l'espace de stockage.
13. **Sys.Modify**: Permet à l'utilisateur de modifier certains paramètres du système nécessaires pour la gestion des VM.
14. **Sys.Console**: Permet à l'utilisateur d'accéder à la console du système.

### Exemple de Configuration de Rôle dans Proxmox

Pour configurer ces droits dans Proxmox, vous pouvez créer un rôle personnalisé et attribuer ce rôle à l'utilisateur. Voici un exemple de configuration de rôle via l'interface Web de Proxmox.

1. **Accédez à l'interface Web de Proxmox**.
2. **Cliquez sur "Datacenter"** dans le menu de navigation de gauche.
3. **Sélectionnez "Permissions"** puis **"Roles"**.
4. **Cliquez sur "Add"** pour créer un nouveau rôle.
5. **Nommez le rôle** (par exemple, `terraform-role`) et cochez les permissions suivantes :
   - VM.Audit
   - VM.Config.Disk
   - VM.Config.CPU
   - VM.Config.Memory
   - VM.Config.Network
   - VM.Config.Options
   - VM.Config.Cloudinit
   - VM.PowerMgmt
   - VM.Monitor
   - VM.Snapshot
   - VM.Clone
   - Datastore.AllocateSpace
   - Sys.Modify
   - Sys.Console

6. **Cliquez sur "Create"** pour sauvegarder le rôle.

### Attribution du Rôle à un Utilisateur

1. **Accédez à "Permissions"** puis **"User Permissions"**.
2. **Cliquez sur "Add"** pour ajouter une nouvelle permission.
3. **Sélectionnez l'utilisateur** auquel vous souhaitez attribuer le rôle.
4. **Sélectionnez le chemin** (par exemple, `/vms/` pour permettre la gestion des VM).
5. **Sélectionnez le rôle** que vous venez de créer (`terraform-role`).
6. **Cliquez sur "Add"** pour appliquer les permissions.

### Exemple d'Attribution des Permissions via la Ligne de Commande

Vous pouvez également attribuer les permissions via la ligne de commande Proxmox. Voici un exemple de commande pour attribuer le rôle à un utilisateur sur toutes les VM :

```sh
pveum role add terraform-role -privs "VM.Audit,VM.Config.Disk,VM.Config.CPU,VM.Config.Memory,VM.Config.Network,VM.Config.Options,VM.Config.Cloudinit,VM.PowerMgmt,VM.Monitor,VM.Snapshot,VM.Clone,Datastore.AllocateSpace,Sys.Modify,Sys.Console"
pveum aclmod /vms -user USER@pve -role terraform-role
```

Remplacez `USER` par le nom de l'utilisateur auquel vous souhaitez attribuer les permissions.

Avec cette configuration, l'utilisateur aura les droits nécessaires pour utiliser le module Terraform `proxmox_vm_qemu` pour créer, gérer et supprimer des machines virtuelles sur votre infrastructure Proxmox.