#!/usr/bin/env bash
cat >stop.sh <<'EOF'
#!/usr/bin/env bash
/usr/bin/aws sagemaker stop-notebook-instance \
    --notebook-instance-name $(jq '.ResourceName' /opt/ml/metadata/resource-metadata.json --raw-output)
EOF
at -f stop.sh ${stop_time}
