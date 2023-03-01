# rookout-packer

Quick start from pre builded OVA image:

1. Download OVA image
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