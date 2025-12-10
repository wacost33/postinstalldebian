#!/bin/bash

# ==================================================================
# Script de configuration Debian EXACTE selon tes spécifications
# Exécuter en root
# ==================================================================

set -e

echo "=================================================="
echo "1. Mise à jour complète du système"
echo "=================================================="
apt update && apt upgrade -y

echo "=================================================="
echo "2. Installation des paquets demandés"
echo "=================================================="
apt install -y ssh zip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba

echo "=================================================="
echo "3. Configuration EXACTE de /etc/nsswitch.conf (avec wins)"
echo "=================================================="
cat > /etc/nsswitch.conf << 'EOF'
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the `glibc-doc-reference' and `info' packages installed, try:
# `info libc "Name Service Switch"' for information about this file.

passwd:     files systemd winbind
group:      files systemd winbind
shadow:     files systemd
gshadow:    files systemd

hosts:      files dns wins
networks:   files

protocols:  db files
services:   db files
ethers:     db files
rpc:        db files

netgroup:   nis
EOF

echo "=> /etc/nsswitch.conf écrit exactement comme demandé"
echo "   $(grep '^hosts:' /etc/nsswitch.conf)"

echo "=================================================="
echo "4. Personnalisation du .bashrc root (décommenter le prompt coloré)"
echo "=================================================="
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
# Décommente tout le bloc du prompt coloré (lignes habituellement 9 à 13 + le if/fi)
sed -i '/#.*if \[ "\$color_prompt" = yes \]; then/,/#.*fi/ s/^#//' /root/.bashrc
sed -i '/#.*unset color_prompt force_color_prompt/ s/^#//' /root/.bashrc
echo "=> Prompt coloré activé pour root"

echo "=================================================="
echo "5. Configuration DNS (exemple Cloudflare + Google)"
echo "   Sauvegarde de l'ancien fichier → /etc/resolv.conf.backup"
echo "=================================================="
cp -f /etc/resolv.conf /etc/resolv.conf.backup 2>/dev/null || true

cat > /etc/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 8.8.4.4
search ton-domaine.local    # ←←← CHANGE ÇA avec ton vrai domaine AD ou laisse vide
EOF

echo "=> /etc/resolv.conf configuré"
echo "   Pense à modifier la ligne 'search' si tu es en domaine Active Directory"

echo "=================================================="
echo "6. Installation officielle de Webmin"
echo "=================================================="
curl -fsSL https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh -o webmin-setup-repo.sh
chmod +x webmin-setup-repo.sh
echo "y" | ./webmin-setup-repo.sh > /dev/null
apt update
apt install -y webmin --install-recommends
rm -f webmin-setup-repo.sh

echo "=================================================="
echo "7. Mise à jour de la base locate"
echo "=================================================="
updatedb &

echo "=================================================="
echo "TOUT EST TERMINÉ !"
echo "Webmin → https://$(hostname -I | awk '{print $1}'):10000"
echo "Pense à autoriser le port 10000 dans ton firewall si besoin"
echo "=================================================="

reboot
