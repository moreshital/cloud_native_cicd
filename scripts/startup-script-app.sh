#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx nginx-common -y
source ~/.profile && source ~/.nvm/nvm.sh && source ~/.bashrc
source /home/ubuntu/google-cloud-sdk/completion.bash.inc && source /home/ubuntu/google-cloud-sdk/path.bash.inc
sleep 60s
cd /home/ubuntu
git clone git@github.com:moreshital/cloud_native_cicd.git
npm install pm2 -g
cd /home/ubuntu/cloud_native_cicd
pm2 start /home/ubuntu/cloud_native_cicd/app/server.js --name "cicd_demo"
sleep 10s
pm2 restart cicd_demo
pm2 save
cat  > ~/cicd.conf << EOF
server {
        listen 80;
        server_name cloud_native.demo.com;
        if (\$http_x_forwarded_proto = "http") {
        return 307 https://\$host\$request_uri;
           }
        #// Change this line to your actual build directory path
        root /home/ubuntu/cloud_native_cicd/app;
        location ~* \.(js)$ {
            proxy_pass http://localhost:3000;
            proxy_set_header Host \$host;
        }
}

EOF
sleep 20s
sudo cp ~/cicd.conf /etc/nginx/sites-available/cicd.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/cicd.conf /etc/nginx/sites-enabled/cicd.conf
