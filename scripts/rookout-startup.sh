#!/usr/bin/env bash

config_directory="/etc/rookout/"

[ -d "$config_directory" ] || sudo mkdir $config_directory

sudo mv /tmp/config $config_directory

sudo mv /tmp/*.service /lib/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start rookout-data-on-prem.service
sudo systemctl start rookout-controller.service

sudo systemctl enable rookout-data-on-prem.service
sudo systemctl enable rookout-controller.service