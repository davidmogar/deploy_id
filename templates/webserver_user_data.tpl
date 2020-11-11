#!/bin/bash

sudo rm -rf /var/www/html
sudo git clone --single-branch -b master ${website_repository} /var/www/html
sudo systemctl reload nginx
