#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

sudo echo "<h1> Nginx Created </h1>" > /var/www/html/index.html