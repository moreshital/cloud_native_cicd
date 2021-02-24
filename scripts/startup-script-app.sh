#!/bin/bash
NODE_ENV=production
echo "NODE_ENV" $NODE_ENV
sudo apt-get update -y
#sudo apt-get install nginx nginx-common -y
source ~/.profile && source ~/.nvm/nvm.sh && source ~/.bashrc
source /home/ubuntu/google-cloud-sdk/completion.bash.inc && source /home/ubuntu/google-cloud-sdk/path.bash.inc
sleep 60s
cd /home/ubuntu
git clone git@github.com:moreshital/cloud_native_cicd.git
npm install pm2 -g
cd /home/ubuntu/cloud_native_cicd

cd /home/ubuntu/cloud_native_cicd/app
echo "Running npm install"
npm install


echo "Running npm ci"
npm run ci

if [ $? == 0 ]
then
  echo "Tests Passed"

else "Tests Failed"
  exit 0
fi

sudo killall node
sleep 10s
echo "Starting PM2 Process"
NODE_ENV=$NODE_ENV pm2 start /home/ubuntu/cloud_native_cicd/app/index.js --name "cicd_demo"
sleep 10s

pm2 restart cicd_demo

echo "Taking dump of PM2 process"
pm2 save

cat /home/ubuntu/.pm2/dump.pm2 | grep NODE_ENV
cat  > ~/cicd.conf << EOF
server {
        listen 80;
        server_name cloud_native.demo.com;
        #// Change this line to your actual build directory path
        root /home/ubuntu/cloud_native_cicd/app;
        location / {
            proxy_pass http://localhost:3000;
            proxy_set_header Host \$host;
        }
}

EOF
sleep 20s
sudo cp ~/cicd.conf /etc/nginx/sites-available/cicd.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/cicd.conf /etc/nginx/sites-enabled/cicd.conf
