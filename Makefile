SHELL := /bin/bash
SSH_WRAPPER=ssh pi@raspberrypi.local

dump-eth0:
	$(SSH_WRAPPER) sudo tcpdump --interface=eth0 port not 22

dump-tun0:
	$(SSH_WRAPPER) sudo tcpdump --interface=tun0 port not 22

dump-eth1:
	$(SSH_WRAPPER) sudo tcpdump --interface=eth1 port not 22

restart-dnsmasq:
	$(SSH_WRAPPER) sudo systemctl restart dnsmasq.service

curl-socks:
	$(SSH_WRAPPER) curl --socks5-hostname 127.0.0.1:1080 https://www.google.com

curl:
	$(SSH_WRAPPER) curl https://www.google.com

trojan-logs:
	$(SSH_WRAPPER) journalctl -u trojan.service -f

tun2socks-logs:
	$(SSH_WRAPPER) journalctl -u tun2socks.service -f

dnsmasq-logs:
	$(SSH_WRAPPER) journalctl -u dnsmasq.service -f

reboot:
	$(SSH_WRAPPER) sudo reboot

sync:
	rsync --rsync-path="sudo rsync" -r -a etc/ pi@raspberrypi.local:/etc
	rsync --rsync-path="sudo rsync" -r -a lib/ pi@raspberrypi.local:/lib
# rsync --rsync-path="sudo rsync" -r -a boot/ pi@raspberrypi.local:/boot