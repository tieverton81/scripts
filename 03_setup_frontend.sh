#!/bin/bash

# Atualizando o sistema e instalando pacotes necessários
echo "Instalando e configurando o frontend..."
cd /home/deploy/whaticket/frontend

sudo su - deploy << EOF
cat <<[-]EOF > /home/deploy/whaticket/frontend/.env
REACT_APP_BACKEND_URL=http://localhost:8080
REACT_APP_HOURS_CLOSE_TICKETS_AUTO = 24
REACT_APP_FACEBOOK_APP_ID=999999999999999999
REACT_APP_NAME_SYSTEM=Canal_Leandro_Reis
NODE_ENV=production
REACT_APP_NUMBER_SUPPORT=5592985549606

[-]EOF
EOF

  sleep 2

npm install && npm run build && npm start