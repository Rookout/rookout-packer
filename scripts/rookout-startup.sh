#!/usr/bin/env bash

set -e

config_directory="/etc/rookout/"

[ -d "$config_directory" ] || sudo mkdir $config_directory
[ -d "$config_directory/controller" ] || sudo mkdir $config_directory/controller
[ -d "$config_directory/data-onprem" ] || sudo mkdir $config_directory/data-onprem

sudo mv /tmp/config $config_directory
sudo mv /tmp/controller_env $config_directory/controller/env
sudo mv /tmp/dop_env $config_directory/data-onprem/env

sudo mv /tmp/*.service /lib/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start rookout-controller.service
sudo systemctl enable rookout-controller.service

sudo systemctl start rookout-data-on-prem.service
sudo systemctl enable rookout-data-on-prem.service