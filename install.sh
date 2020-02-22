#!/bin/bash

rm -rf aws-app/build
rm -rf aws-app/node_modules
cp -R ./ ../backend

cd ../backend
cp Dockerfile-backend Dockerfile
sudo docker build -t node-backend .

BACKEND_ID=$(sudo docker run -d --net=host --rm node-backend)
BACKEND_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $BACKEND_ID)

cd ../aws-hackathon
# sed -i "s/http:\/\/localhost:9000\/testAPI/http:\/\/$BACKEND_IP:9000\/testAPI/g" aws-app/src/containers/Test.js

cp Dockerfile-front Dockerfile
sudo docker build -t node-front .

sudo docker run -d --rm --net=host -p:80:5000 node-front
