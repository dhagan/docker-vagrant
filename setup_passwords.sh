USERNAME=$1
PASSWORD=$2

passwd $USERNAME << EOF
vagrant
vagrant
EOF

smbpasswd -a $USERNAME << EOF
vagrant
vagrant
EOF