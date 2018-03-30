#!/bin/bash

systemctl is-active iptables && \
iptables -I INPUT 5 -p tcp --dport 4369 -m state --state NEW -j ACCEPT && \
iptables -I INPUT 5 -p tcp --dport 15672 -m state --state NEW -j ACCEPT && \
iptables -I INPUT 5 -p tcp --dport 25672 -m state --state NEW -j ACCEPT && \
iptables -I INPUT 5 -p tcp --dport 5672 -m state --state NEW -j ACCEPT && \
service iptables save

systemctl is-active firewalld &>/dev/null && firewall-cmd --add-port=4369/tcp --permanent && \
firewall-cmd --add-port=15672/tcp --permanent && \
firewall-cmd --add-port=25672/tcp --permanent && \
firewall-cmd --add-port=5672/tcp --permanent && \
systemctl restart firewalld
