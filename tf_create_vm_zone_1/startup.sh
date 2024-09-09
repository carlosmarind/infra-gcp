#sources for gcloud y docker
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
## apt install 
sudo apt update 
sudo apt upgrade -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin iputils-ping iputils-ping telnet apt-transport-https ca-certificates gnupg curl google-cloud-cli kubectl google-cloud-sdk-gke-gcloud-auth-plugin ca-certificates curl
#configuracion host
sudo useradd -m -s /bin/bash ${username}
sudo usermod -aG sudo,docker ${username}
echo "${username}:${password}" | sudo chpasswd;
sudo echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
sudo rm /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
sudo systemctl restart sshd
#echo "${sa-config}" | sudo -i -u ${username} docker login -u _json_key_base64 --password-stdin https://${region}-docker.pkg.dev
su -c "mkdir /home/${username}/registry" ${username}
echo "${sa-config}" | su -c "tee /home/${username}/registry/config.json" ${username}