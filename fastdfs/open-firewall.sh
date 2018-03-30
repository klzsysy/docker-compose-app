systemctl stop firewalld
open_firewadd(){
    if $(rpm -qa | grep iptables-services -q);then
        systemctl start iptables && \
        systemctl enable iptables && \
        iptables -I INPUT 4 -p tcp -m state --state NEW --dport 22122 -j ACCEPT && \
        iptables -I INPUT 4 -p tcp -m state --state NEW --dport 23000 -j ACCEPT && \
        iptables -I INPUT 4 -p tcp -m state --state NEW --dport 8080 -j ACCEPT && \
        service iptables save
    else
        yum install -y iptables-services && open_firewadd
    fi
}

open_firewadd