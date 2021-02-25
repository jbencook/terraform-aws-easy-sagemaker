#!/usr/bin/env bash
sudo -u ec2-user -i <<'EOF'
conda activate python3
pip install omegaconf
conda deactivate
EOF