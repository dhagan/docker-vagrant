mkdir -p ~/.ssh

# REPLACE CONTENT WITH CONTENT FROM ~/.ssh/id_rsa.pub
cat > ~/.ssh/halfaker_bb_id_rsa.pub <<\EOF
----------PUT CONTENTS HERE----------
EOF

# REPLACE CONTENT WITH CONTENT FROM ~/.ssh/id_rsa
cat > ~/.ssh/halfaker_bb_id_rsa <<\EOF
----------PUT CONTENTS HERE----------
EOF

chmod 600 ~/.ssh/halfaker_bb_id_rsa.pub
chmod 600 ~/.ssh/halfaker_bb_id_rsa

cat > ~/.ssh/config <<\EOF
Host bitbucket.org
Hostname bitbucket.org
IdentityFile ~/.ssh/halfaker_bb_id_rsa
IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config

echo Done
