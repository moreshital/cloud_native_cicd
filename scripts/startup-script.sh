#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx nginx-common nodejs npm -y
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.profile
source ~/.nvm/nvm.sh
source ~/.bashrc
npm install npm@6.9.0 -g
nvm install 10.15.1
node -v
npm -v
sudo su - ubuntu
curl https://sdk.cloud.google.com | bash
source /home/ubuntu/google-cloud-sdk/completion.bash.inc
source /home/ubuntu/google-cloud-sdk/path.bash.inc
sleep 60s
cd /home/ubuntu
gcloud secrets versions access latest --secret=shital_private_key > /home/ubuntu/.ssh/id_github
sleep 10s
chmod 600 /home/ubuntu/.ssh/id_github
ls -la /home/ubuntu/.ssh/id_github
cat <<EOF >/home/ubuntu/.ssh/config
  Hostname bitbucket.org
  IdentityFile /home/ubuntu/.ssh/id_github
EOF
chmod 400 /home/ubuntu/.ssh/config
ssh-keyscan -t rsa bitbucket.org > /home/ubuntu/.ssh/known_hosts
cd /home/ubuntu
git clone git@bitbucket.org:ovoeng/beartooth-poc-gcp.git
cd beartooth-poc-gcp
git pull origin gcp-migration
npm ci
npm run build:staging
#nohup npm start &

cat  > ~/beartooth.conf << EOF
server {
        listen 80;
        server_name help-center.ovo.test;
        #// Change this line to your actual build directory path
        root //home/ubuntu/beartooth-poc-gcp/build;
        location / {
                index index.html;
                if (!-e \$request_filename) {
                        rewrite ^(.+)$ /index.html;
                        break;
                }
        }
}

EOF
sudo cp ~/beartooth.conf /etc/nginx/sites-available/beartooth.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/beartooth.conf /etc/nginx/sites-enabled/beartooth.conf
