## Cài đặt OpenStack Juno 2node

Script này dùng để cài đặt OpenStack Juno trên Ubuntu 14.04

Script nguồn [VietStack](https://github.com/vietstacker/openstack-juno-multinode-U14.04-v1)

####Lưu ý: trong script này tôi đã sửa đổi so với script gốc của vietstack một số điểm như sau:

- Không sử dụng mật khẩu mặc định mà sinh pass random.

- Gộp 2 mạng MGNT và VM Data thành một mạng.

- Tách Cinder thành một node riêng biệt.

- Các bạn có thể không sử dụng Cinder bằng cách không chạy lệnh `bash control-9.cinder.sh` trên `Controller` và bỏ qua cài đặt trên `Cinder Node`

## Mô hình mạng

![Alt text](http://i.imgur.com/jPTgNjI.png)

Bạn cần đảm bảo đấu nối đúng như mô hình trên, bên cạnh đó cần phải thêm trên node compute1 card eth1 nối ra internet và node Cinder card eth2 nối ra internet để tải gói. Sau khi cài đặt xong hai card này bỏ không cần dùng nữa

## Thực hiện

```sh
## Trên cả 3 node
apt-get install git -y
git clone https://github.com/ducnc/Juno2net.git
cd Juno2net/

## CONTROLLER
bash gen_pass.sh
scp config.cfg root@10.10.10.42:/root/Juno2net
scp config.cfg root@10.10.10.43:/root/Juno2net
scp config.cfg root@10.10.10.44:/root/Juno2net
bash control-1.ipadd.sh
#may ao bi reboot, reconect ssh
cd Juno2net/
bash control-2.prepare.sh
bash control-3.create-db.sh
bash control-4.keystone.sh
bash control-5-creatusetenant.sh
bash control-6.glance.sh
bash control-7.nova.sh
bash control-8.neutron.sh
bash control-9.cinder.sh


## NETWORK
bash net-ipadd.sh
#may ao bi reboot, reconect ssh
cd Juno2net/
bash net-prepare.sh

## COMPUTE
bash com1-ipdd.sh
#may ao bi reboot, reconect ssh
cd Juno2net/
bash com1-prepare.sh

## Storage node
bash storage-1-ipadd.sh
#may ao shutdown, cam dai MGNT vao card eth1 va bat may ao len
cd Juno2net/
bash storage-2-prepare.sh

## Controller again
cd /root/juno-ubuntu14.04
bash control-horizon.sh
bash creat-network.sh

Reboot lai cac node

``sh