#!/bin/bash

# Atualizando o sistema e instalando pacotes necessários
echo "Atualizando o sistema e instalando dependências..."
apt update && apt install -y \
    libxshmfence-dev libgbm-dev wget unzip fontconfig locales gconf-service \
    libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
    libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 \
    libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release \
    xdg-utils apt-transport-https ca-certificates curl software-properties-common
sleep 2
echo "[OK] Dependências instaladas."

# Configurando Node.js
echo "Instalando Node.js..."
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
#curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs
npm install -g npm@latest
sleep 2
echo "[OK] Node.js instalado."

# Configurando PostgreSQL
echo "Instalando PostgreSQL..."
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee /etc/apt/trusted.gpg.d/ACCC4CF8.asc
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c | awk "{print \$2}")-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
dpkg --remove-architecture i386
apt update && apt install -y postgresql postgresql-contrib
sleep 2
echo "[OK] PostgreSQL instalado."

# Configurando Docker
echo "Instalando Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update && apt install -y docker-ce
sleep 2
echo "[OK] Docker instalado."

echo "Configurando Docker para o usuário 'deploy' e criando container Redis..."
usermod -aG docker deploy
docker run --name redis-whaticket -p 5000:6379 --restart always --detach redis redis-server --requirepass 123456
sleep 2
echo "[OK] Docker configurado e container Redis criado."

# Configurando banco de dados PostgreSQL
echo "Configurando banco de dados PostgreSQL..."
sudo -u postgres createdb whaticket
sudo -u postgres psql -c "CREATE USER whaticket SUPERUSER INHERIT CREATEDB CREATEROLE;"
sudo -u postgres psql -c "ALTER USER whaticket PASSWORD '123456';"
sleep 2
echo "[OK] Banco de dados configurado."

# Instalando PM2
echo "Instalando PM2..."
npm install -g pm2
sleep 2
echo "[OK] PM2 instalado."

# Instalando Snap
echo "Instalando Snap..."
apt install -y snapd && snap install core && snap refresh core
sleep 2
echo "[OK] Snap instalado."

# Clonando repositório
echo "Clonando repositório Whaticket..."
git clone https://github.com/tieverton81/whaticket-main.git /home/deploy/whaticket
chown deploy:deploy -R /home/deploy/whaticket
sleep 2
echo "[OK] Repositório clonado."

echo " "
echo "Faça login com a conta do usuário deploy para finalizar a instalação e configuração"
