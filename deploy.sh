#!/bin/bash

function deploy() {
	IP=$1
	ssh -oStrictHostKeyChecking=accept-new root@$IP -t -- "{
		apt-get update
		apt-get install -y libgmp10 libc6 screen
		ufw allow 53/udp
		ufw allow 53/tcp
	}"

	scp config root@$IP:~/
	scp bin/dnsflare-debian root@$IP:~/dnsflare
	ssh -f root@$IP "sh -c 'nohup ./dnsflare &> /dev/null &'"
}

deploy $(terraform output -state=terraform/terraform.tfstate -raw ns1_ip_addr)
deploy $(terraform output -state=terraform/terraform.tfstate -raw ns2_ip_addr)
