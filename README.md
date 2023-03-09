# rookout-packer

## Quick start from pre builded OVA image:

1. Download OVA image and validate checksum
```
wget https://rookout-fibi-vm-solution.s3.amazonaws.com/2023-03-08-1e28fd2b/rookout-ubuntu-2023-03-08-1e28fd2b.ova
wget https://rookout-fibi-vm-solution.s3.amazonaws.com/2023-03-08-1e28fd2b/SHA256SUM
sha256sum -c SHA256SUM

```
2. Import VM from image
3. SSH to yor VM using username: `admin` and password: `packerubuntu`
4. Change `ROOKOUT_TOKEN` value in `/etc/rookout/config` file
5. Restart `rookout-controller` and `rookout-data-on-prem` services
```
sudo systemctl start rookout-controller.service

sudo systemctl restart rookout-data-on-prem.service
```
6. Checking connectivity on localhost
```
curl localhost:7488

curl localhost:8080
```
You must get outputs:
```
Rookout Service [OK] - connect to this endpoint using our SDK. More information is available on https://docs.rookout.com

and

Rookout Datastore [OK] - finish the installation by following the instructions at https://docs.rookout.com/docs/dop-install/
```
6. Remove `admin` user and configure ssh access regarding your security policies
7. Change your network configuration regarding your network policies

## Controller an Data-On-Prem configuration

Edit `/etc/rookout/config/controller/env` and `/etc/rookout/config/data-onprem/env` and restart `rookout-controller` and `rookout-data-on-prem` services

## How to configure TLS

Data-OnPrem:
1. Set value of `ROOKOUT_DOP_SERVER_MODE` to `TLS` in data-onprem config (`/etc/rookout/config/data-onprem/env`) file
2. Place certificate and key to `/etc/rookout/config/data-onprem/certs` directory as `cert.pem` and `key.pem`
3. If you are using self-signed cerificate, set value of `ROOKOUT_DOP_NO_SSL_VERIFY` in controller config (`/etc/rookout/config/controller/env`) to `true` (Required `rookout-controller` service restart)
4. Restart `rookout-data-on-prem` service 

Controller:
1. Set value of `ROOKOUT_CONTROLLER_SERVER_MODE` to `TLS` in controller config (`/etc/rookout/config/data-onprem/env`) file
2. Place certificate and key to `/etc/rookout/config/controller/certs` directory as `tls.crt` and `tls.key`
3. Restart `rookout-controller` service 

## Default Inbound Ports

- 7488 : Controller Port, must be open for inbound and outbound connections
- 8080 : Data-OnPrem Port, must be open for inbound and outbound connections

## Build image with packer

Suported builder: `vmware-iso` https://developer.hashicorp.com/packer/plugins/builders/vmware/iso

Supported source OS: `ubuntu`

Requred VMware Fusion for OS X, VMware Workstation for Linux and Windows or VMware Player on Linux.

Requred ovftool.

```
packer build -var "token=YOUR_TOKEN" .
```
 