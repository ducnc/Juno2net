#!/bin/bash

cat  EOF > config.cfg

## Assigning IP for CONTROLLER NODE
CON_MGNT_IP=10.10.10.51
CON_EXT_IP=192.168.1.51

# Assigning IP for NETWORK NODE
NET_MGNT_IP=10.10.10.52
NET_EXT_IP=192.168.1.52
NET_DATA_VM_IP=10.10.10.52

# Assigning IP for COMPUTE1 NODE
COM1_MGNT_IP=10.10.10.53
COM1_EXT_IP=192.168.1.53
COM1_DATA_VM_IP=10.10.10.53

# Assigning IP for COMPUTE2 NODE
COM2_MGNT_IP=10.10.10.54
COM2_EXT_IP=192.168.1.54
COM2_DATA_VM_IP=10.10.10.54

#Gateway for EXT network
GATEWAY_IP=192.168.1.1
NETMASK_ADD=255.255.255.0

# Set password
DEFAULT_PASS='Welcome123'

RABBIT_PASS=`openssl rand -hex 10`
MYSQL_PASS=`openssl rand -hex 10`
TOKEN_PASS=`openssl rand -hex 10`
ADMIN_PASS=`openssl rand -hex 10`
DEMO_PASS=`openssl rand -hex 10`
SERVICE_PASSWORD=`openssl rand -hex 10`
METADATA_SECRET=`openssl rand -hex 10`

SERVICE_TENANT_NAME="service"
ADMIN_TENANT_NAME="admin"
DEMO_TENANT_NAME="demo"
INVIS_TENANT_NAME="invisible_to_admin"
ADMIN_USER_NAME="admin"
DEMO_USER_NAME="demo"

# Environment variable for OPS service
KEYSTONE_PASS=`openssl rand -hex 10`
GLANCE_PASS=`openssl rand -hex 10`
NOVA_PASS=`openssl rand -hex 10`
NEUTRON_PASS=`openssl rand -hex 10`
CINDER_PASS=`openssl rand -hex 10`

# Environment variable for DB
KEYSTONE_DBPASS=`openssl rand -hex 10`
GLANCE_DBPASS=`openssl rand -hex 10`
NOVA_DBPASS=`openssl rand -hex 10`
NEUTRON_DBPASS=`openssl rand -hex 10`
CINDER_DBPASS=`openssl rand -hex 10`

# User declaration in Keystone
ADMIN_ROLE_NAME="admin"
MEMBER_ROLE_NAME="Member"
KEYSTONEADMIN_ROLE_NAME="KeystoneAdmin"
KEYSTONESERVICE_ROLE_NAME="KeystoneServiceAdmin"


# OS_SERVICE_TOKEN=`openssl rand -hex 10`

EOF
