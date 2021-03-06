#!/usr/bin/env bash

# https://www.howtoforge.com/tutorial/install-mongodb-on-ubuntu-16.04/
# Setup for Mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Update apt-get
apt-get update

# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
apt-get install -y build-essential

# Install Mongodb
# https://www.howtoforge.com/tutorial/install-mongodb-on-ubuntu-16.04/
apt-get install -y mongodb-org

if ! grep "# VAGRANT" /lib/systemd/system/mongod.service; then
rm /lib/systemd/system/mongod.service
cat <<EOF >> /lib/systemd/system/mongod.service
# VAGRANT SETUP
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF
systemctl start mongod
systemctl enable mongod
mongo < /vagrant/mongo_setup.js
sed "s/--quiet/--quiet --auth/g" /lib/systemd/system/mongod.service
systemd daemon-reload
sudo service mongod restart
else
  echo "mongod.service already setup"
fi

npm install -g nodemon
npm install -g node-inspector

cd /vagrant/beerlocker
npm install
