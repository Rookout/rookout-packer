# Controller configuration
# Docs: https://docs.rookout.com/docs/etl-controller-config/#environment-variables

## Configure the Controller to either use TLS encryption (TLS mode) or plain text (PLAIN mode) for incoming connections
## (SDK instances connecting to the Controller).
ROOKOUT_CONTROLLER_SERVER_MODE=${server_mode}
ROOKOUT_CONTROLLER_CERT_PATH=${certs_path}
## Set this to true to make the Controller skip the verification of SSL certificates when connecting to the Datastore.
# ROOKOUT_DOP_NO_SSL_VERIFY=false

##Set this to your proxy URL/address to have the Controller manually connect through it.
# ROOKOUT_PROXY=""
# ROOKOUT_PROXY_USERNAME=""
# ROOKOUT_PROXY_PASSWORD=""

## Set this configuration to false to send data collected by the Controller only to targets and not to Rookout's servers.
# ROOKOUT_SEND_DATA=true

## Max CPU cores
# ROOKOUT_CONTROLLER_MAX_CPU=1
## Max Memory in MegaBytes
# ROOKOUT_CONTROLLER_MAX_MEMORY=512

