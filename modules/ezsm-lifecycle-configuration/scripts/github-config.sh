#!/usr/bin/env bash
sudo -u ec2-user -i <<EOF
git config --global user.name ${username}
git config --global user.email ${email}
EOF
