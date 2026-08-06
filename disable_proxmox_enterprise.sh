echo 'Enabled: false' >> /etc/apt/sources.list.d/pve-enterprise.sources

CODENAME=$(grep VERSION_CODENAME /etc/os-release | tr -d '"' | cut -d= -f2)

cat > /etc/apt/sources.list.d/pve-no-subscription.sources << 'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: $CODENAME
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
