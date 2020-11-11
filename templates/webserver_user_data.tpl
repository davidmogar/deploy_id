#!/bin/bash

sudo rm -rf /var/www/html
sudo git clone --single-branch -b main ${website_repository} /var/www/html
sudo systemctl reload nginx
