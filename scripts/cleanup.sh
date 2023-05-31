#!/usr/bin/env bash

set -e

sudo sed -i 's/${ROOKOUT_TOKEN}/dummy_token/g' /etc/rookout/config

sudo systemctl restart rookout-controller.service
sudo systemctl restart rookout-data-on-prem.service
