#!/bin/bash

set -e

dir=$1
appuser=$(whoami)
appgroup=$appuser

service="[Unit]
Description=KartennAPI Service
After=network-online.target

[Service]
Type=simple
WorkingDirectory=$dir

User=$appuser
Group=$appgroup
UMask=007

Restart=always

ExecStart=$dir/startKartennAPI.sh

[Install]
WantedBy=multi-user.target"

sudo echo $service > /etc/systemd/system/kartennapi.service
sudo chmod 644 /etc/systemd/system/kartennapi.service

sudo systemctl enable kartennapi