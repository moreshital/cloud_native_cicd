#!/bin/bash
#Install node dependencies
sudo apt-get update -y
sudo apt-get install nginx screen
sudo wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm --version
nvm install 12.16.2
nvm use 12.16.2
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
sudo apt -y install gcc g++ make
sudo apt-get install build-essential
npm install pm2@latest -g
node -v
npm -v


#Install gcloud cli
sudo su - ubuntu
curl https://sdk.cloud.google.com | bash
source /home/ubuntu/google-cloud-sdk/completion.bash.inc
source /home/ubuntu/google-cloud-sdk/path.bash.inc
sleep 60s

#Download ssh private key in order to get access of repo
cd /home/ubuntu
gcloud secrets versions access latest --secret=cicd_demo > /home/ubuntu/.ssh/id_github
sleep 10s
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/id_github
ls -la /home/ubuntu/.ssh/id_github
cat <<EOF >/home/ubuntu/.ssh/config
  Hostname github.com
  IdentityFile /home/ubuntu/.ssh/id_github
EOF
chmod 400 /home/ubuntu/.ssh/config
ssh-keyscan -t rsa github.com > /home/ubuntu/.ssh/known_hosts

#Install Stackdriver agent to monitor memory
#curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
#sudo bash add-monitoring-agent-repo.sh
#sudo apt-get update
#sudo apt-cache madison stackdriver-agent
#sudo apt-get install -y 'stackdriver-agent=6.*'
#sudo apt-get install stackdriver-agent -y
#sudo service stackdriver-agent start
