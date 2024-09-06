sudo apt update 
sudo apt upgrade
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo useradd -m -s /bin/bash ${username}
sudo usermod -aG sudo,docker ${username}
#sudo apt install apache2 -y 
#echo "<!doctype html><html><body><h1>Hello World!${instance}</h1></body></html>" | sudo tee "/var/www/html/index.html"
echo "${username}:${password}" | sudo chpasswd;
sudo echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
sudo rm /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
sudo systemctl restart sshd
#echo "${sa-config}" | sudo -i -u ${username} docker login -u _json_key_base64 --password-stdin https://${region}-docker.pkg.dev
su -c "mkdir /home/${username}/registry" ${username}
echo "${sa-config}" | su -c "tee /home/${username}/registry/config.json" ${username}
