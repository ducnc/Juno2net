#!/bin/bash -ex
source ./config.cfg

echo "########## Create Physical Volume and Volume Group (in sdb disk ) ##########"
sleep 5
fdisk -l
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb

echo "########## Configuring for lvm.conf ##########"
sed  -r -e 's#(filter = )(\[ "a/\.\*/" \])#\1[ "a\/sda5\/", "a\/sdb\/", "r/\.\*\/"]#g' /etc/lvm/lvm.conf

echo "########## Configuring for cinder.conf ##########"
sleep 5

filecinder=/etc/cinder/cinder.conf
test -f $filecinder.orig || cp $filecinder $filecinder.orig
rm $filecinder

cat << EOF > $filecinder
[DEFAULT]
verbose = True

rootwrap_config = /etc/cinder/rootwrap.conf
api_paste_confg = /etc/cinder/api-paste.ini
iscsi_helper = tgtadm
volume_name_template = volume-%s
volume_group = cinder-volumes
state_path = /var/lib/cinder
lock_path = /var/lock/cinder
volumes_dir = /var/lib/cinder/volumes

auth_strategy = keystone

rpc_backend = rabbit
rabbit_host = $CON_MGNT_IP
rabbit_password = $RABBIT_PASS

my_ip = $STO_MGNT_IP

glance_host = $CON_MGNT_IP

[keystone_authtoken]
auth_uri = http://$CON_MGNT_IP:5000/v2.0
identity_uri = http://$CON_MGNT_IP:35357
admin_tenant_name = service
admin_user = cinder
admin_password = $CINDER_PASS

[database]
connection = mysql://cinder:$CINDER_DBPASS@$CON_MGNT_IP/cinder

EOF

service tgt restart
service cinder-volume restart

rm -f /var/lib/cinder/cinder.sqlite

echo "########## Finish Configuring and reboot ##########"
sleep 10
reboot
