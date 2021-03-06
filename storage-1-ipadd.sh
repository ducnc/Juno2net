#!/bin/bash -ex
source ./config.cfg

#Update for Ubuntu

apt-get -y install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list

apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

# Cau hinh hostname, hosts

echo "##### Configuring hostname for Storage node... #####"
sleep 3
echo "block1" > /etc/hostname
hostname -F /etc/hostname

iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost
cat << EOF >> $iphost
127.0.0.1       localhost
$CON_MGNT_IP    controller
$COM1_MGNT_IP      compute1
$COM2_MGNT_IP	compute2
$NET_MGNT_IP     network
$STO_MGNT_IP    block1
EOF


# Cau hinh ntp

apt-get install ntp -y
apt-get install python-mysqldb -y
#
echo "##### Backup NTP configuration... ##### "
sleep 7 
cp /etc/ntp.conf /etc/ntp.conf.bka
rm /etc/ntp.conf
cat /etc/ntp.conf.bka | grep -v ^# | grep -v ^$ >> /etc/ntp.conf
#
sed -i 's/server 0.ubuntu.pool.ntp.org/ \
#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 1.ubuntu.pool.ntp.org/ \
#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 2.ubuntu.pool.ntp.org/ \
#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 3.ubuntu.pool.ntp.org/ \
#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i "s/server ntp.ubuntu.com/server $CON_MGNT_IP iburst/g" /etc/ntp.conf

# Tai lvm

apt-get install -y lvm2 cinder-volume

# Cau hinh IP

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Storage node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# Storage NETWORK
auto eth0
iface eth0 inet static
address $STO_STO_IP
netmask $NETMASK_ADD


# MGNT NETWORK
auto eth1
iface eth1 inet static
address $STO_MGNT_IP
netmask $NETMASK_ADD
#gateway $GATEWAY_IP
#dns-nameservers 8.8.8.8

EOF


echo "Shutdown de doi card mang eth1 sang dai MGNT"
sleep 30
shutdown -h now
