#!/usr/bin/env bash
# Original source: https://github.com/mariokostelac/sagemaker-setup
echo "Setting up ssh with ngrok..."

echo "Downloading ngrok..."
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
unzip -o ngrok.zip
mv ./ngrok /usr/local/bin/ngrok

cat > /usr/local/bin/start-ngrok-ssh <<EOF
#!/usr/bin/env bash
ngrok tcp 22 --log=stdout > /home/ec2-user/SageMaker/ngrok.log &
EOF
chmod +x /usr/local/bin/start-ngrok-ssh

sudo -u ec2-user -i <<EOF
ngrok authtoken $(aws secretsmanager get-secret-value --secret-id ${secret_id} | jq '.SecretString' --raw-output | jq '.authtoken')
aws secretsmanager get-secret-value --secret-id ${secret_id} | jq '.SecretString' --raw-output | jq '.public_keys' --raw-output >> /home/ec2-user/.ssh/authorized_keys
start-ngrok-ssh
EOF
