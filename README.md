# Debian Post-Install Script 
Objectif du projet
Ce script unique fait TOUT ce qu’on fait manuellement après une installation fraîche de Debian:

Mise à jour complète du système
Installation de tous les outils de base (ssh, nmap, ncdu, git, screen, lynx, etc.)
Configuration Samba / Winbind (intégration Active Directory prête)
Configuration exacte de /etc/nsswitch.conf avec support WINS
Prompt coloré root activé (parce qu’on aime quand c’est beau)
DNS rapides (Cloudflare + Google)
Installation officielle de Webmin (interface web 10000/tcp)
Base locate mise à jour en arrière-plan

Résultat : tu passes de Debian minimal à machine prête à l’emploi en exécutant un seul fichier.
Utilisation (3 commandes)
Bash# 1. Récupérer le script
wget https://raw.githubusercontent.com/tonpseudo/debian-postinstall/main/setup-debian.sh

# Le rendre exécutable
chmod +x setup-debian.sh

# Lancer en root
sudo ./setup-debian.sh
C’est tout.
Ce que le script fait exactement


ÉtapeAction réalisée1   Mise à jourapt update && apt upgrade -y2   Outils réseau / adminssh, nmap, zip, curl, git, screen, ncdu, locate, lynx, net-tools, dnsutils, etc.3   Intégration AD / Sambawinbind + samba installés + /etc/nsswitch.conf configuré avec wins et winbind4   Prompt rootDécommentage du bloc force_color_prompt=yes (lignes 9-13 du .bashrc)5   DNS rapides1.1.1.1 / 8.8.8.8 / 8.8.4.4 + ligne search personnalisable6   WebminAjout dépôt officiel + installation complète7   Base locateupdatedb lancé en arrière-plan
À personnaliser (1 seule ligne)
Ouvre le script et change cette ligne si tu es en domaine Active Directory :
Bashsearch ton-domaine.local    # ← remplace par exemple entreprise.local
Prérequis
Accès root ou sudo
Connexion Internet

Sécurité
Le script ouvre le port 10000 pour Webmin.
Si tu es en environnement exposé, pense à restreindre l’accès :
Bashufw allow from 192.168.1.0/24 to any port 10000   # exemple réseau local
ufw allow from ton.ip.perso to any port 10000
