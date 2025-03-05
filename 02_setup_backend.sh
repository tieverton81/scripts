#!/bin/bash

# Atualizando o sistema e instalando pacotes necessários
echo "Instalando e configurando o backend..."
cd /home/deploy/whaticket/backend

sudo su - deploy << EOF
cat <<[-]EOF > /home/deploy/whaticket/backend/.env
NODE_ENV=
BACKEND_URL=http://localhost
FRONTEND_URL=http://localhost:3000
PROXY_PORT=8080
PORT=8080

DB_DIALECT=postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=whaticket
DB_PASS=123456
DB_NAME=whaticket

JWT_SECRET=kZaOTd+YZpjRUyyuQUpigJaEMk4vcW4YOymKPZX0Ts8=
JWT_REFRESH_SECRET=dBSXqFg9TaNUEDXVp6fhMTRLBysP+j2DSqf7+raxD3A=

REDIS_URI=redis://:123456@127.0.0.1:5000
REDIS_OPT_LIMITER_MAX=1
REDIS_OPT_LIMITER_DURATION=3000

USER_LIMIT=10000
CONNECTIONS_LIMIT=100000
CLOSED_SEND_BY_ME=true

GERENCIANET_SANDBOX=false
GERENCIANET_CLIENT_ID=Client_Id_Gerencianet
GERENCIANET_CLIENT_SECRET=Client_Secret_Gerencianet
GERENCIANET_PIX_CERT=certificado-Gerencianet
GERENCIANET_PIX_KEY=chave pix gerencianet

[-]EOF
EOF

  sleep 2

npm install && npm run build
npx sequelize db:migrate
npx sequelize db:seed:all
npm start
sleep 2
echo "[OK]"