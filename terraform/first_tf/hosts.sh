#!/bin/sh

hosts='invintory/hosts'
pub_ip=$(terraform output vm_ip)

echo $pub_ip

cat <<EOF > hosts
host1 ansible_ssh_port=22 ansible_ssh_host=$pubip
EOF
