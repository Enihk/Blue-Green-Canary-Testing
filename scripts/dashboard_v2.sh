#!/bin/bash
exec > /var/log/dashboard-service.log 2>&1
set -x

# ============ KEY SETUP ============
# dashboard-v2 instance SSH into counting instances.
# ${private_key} = counting tier's private key
mkdir -p /home/ubuntu/.ssh
cat > /home/ubuntu/.ssh/counting-key.pem << 'KEYEOF'
${private_key}
KEYEOF
chmod 400 /home/ubuntu/.ssh/counting-key.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/counting-key.pem
# ===================================

sudo apt update -y
sudo apt-get install net-tools zip curl jq tree unzip wget siege apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y
sudo curl -L https://github.com/Enihk/demo-consul-101/releases/download/v0.2.0/dashboard-service_linux_amd64.zip -o dashboard-service.zip
sudo unzip dashboard-service.zip
sudo rm -rf dashboard-service.zip
sudo mv dashboard-service_linux_amd64 dashboard-service
sudo mv dashboard-service /usr/bin/dashboard-service
sudo chmod 755 /usr/bin/dashboard-service
sudo chown ubuntu:ubuntu /usr/bin/dashboard-service

cat <<SERVICEEOF | sudo tee /usr/lib/systemd/system/dashboard-api.service
[Unit]
Description=Dashboard API service
After=syslog.target network.target
[Service]
Environment=PORT="8080"
Environment=COUNTING_SERVICE_URL="${counting_service_url}"
ExecStart=/usr/bin/dashboard-service
User=ubuntu
Group=ubuntu
ExecStop=/bin/sleep 5
Restart=always
[Install]
WantedBy=multi-user.target
SERVICEEOF

sudo systemctl daemon-reload
sleep 1
sudo systemctl enable dashboard-api.service
sudo systemctl start dashboard-api.service
sleep 1
sudo systemctl status dashboard-api.service
sudo lsof -i -P | grep dashboard
