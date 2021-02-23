#!/usr/bin/env bash
set -e

echo "Fetching the autostop script"
wget -O autostop.py https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/c9e62e1898e788a321caae437ac7686aa3da07d1/scripts/auto-stop-idle/autostop.py

echo "Starting the SageMaker autostop script in cron"
(crontab -l 2>/dev/null; echo "*/5 * * * * /bin/bash -c '/usr/bin/python3 $DIR/autostop.py --time ${idle_time} | tee -a /home/ec2-user/SageMaker/auto-stop-idle.log'") | crontab -

echo "Changing cloudwatch configuration"
curl https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/549a931b4cf219c49d93f9229876510c0407f374/scripts/publish-logs-to-cloudwatch/on-start.sh | sudo bash -s auto-stop-idle /home/ec2-user/SageMaker/auto-stop-idle.log
