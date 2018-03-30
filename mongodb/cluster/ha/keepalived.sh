#!/bin/bash
# install keepalived in host group

inventory=${inventory:="../hosts.conf"}


pre_check(){
    which nslookup &>/dev/null || yum install -y bind-utils
    if [ "${drect}" == "on" ];then
        return 0
    fi
    mkdir -p  rpm
    ls -l ./rpm/keepalived*.rpm &>/dev/null && return 0 || \
    yum reinstall  -y keepalived iptables-services --downloadonly --downloaddir=./rpm
    ls -l ./rpm/keepalived*.rpm &>/dev/null || exit 1
}

install_rpm_to_host_group(){
    if [ "${drect}" == "on" ];then
        ansible -i ${inventory} ${host_group} -m shell -a 'yum install -y keepalived iptables-services'
    else
        ansible -i ${inventory}  ${host_group} -m copy -a 'src=./rpm dest=/tmp/'
        ansible -i ${inventory}  ${host_group} -m shell -a 'yum -y localinstall /tmp/rpm/*.rpm && rm -rf /tmp/rpm/'
    fi
    ansible -i ${inventory}  ${host_group} -m copy -a 'src=./check_status.sh dest=/etc/keepalived/'
    ansible -i ${inventory}  ${host_group} -m shell -a 'chmod a+x /etc/keepalived/check_status.sh'
}

configure_keepalived(){
    # 1 - 99 
    _id=$(date +%s | tail -c 3 | grep -o -P '[1-9]\d+$')

    for host in $(ansible -i ${inventory}  ${host_group} --list-hosts | tail -n +2)
    do
        out=$(nslookup ${host})
        if [ $? -eq 0 ];then
            host_ip=$(echo "${out}" | tail -n 1 | tr -d "Address: ")
            
            cat "keepalived.conf" | sed "s/VIP/${vip}/g" | \
            sed "s/INT/${interface}/g" | \
            sed "s/virtual_router_id.*/virtual_router_id ${_id}/g" | \
            ssh root@${host} 'cat > /etc/keepalived/keepalived.conf'
        else
            echo "Error! not nslookup ${host}"
            exit 1
        fi
    done


    ansible -i ${inventory}  ${host_group} -m shell -a 'systemctl stop firewalld ; systemctl disable firewalld ; systemctl start iptables ; systemctl enable iptables '
    ansible -i ${inventory}  ${host_group} -m iptables -a "chain=INPUT protocol=vrrp destination=224.0.0.0/8 jump=ACCEPT comment=open_vrrp action=insert in_interface=${interface}"
    ansible -i ${inventory}  ${host_group} -m shell -a 'service iptables save'
    ansible -i ${inventory}  ${host_group} -m shell -a 'systemctl restart keepalived && systemctl enable keepalived'

}

helper(){
    cat <<'EOF'
Usage:
    nstall:
    ./keepalived.sh install host    network interface       virtual ip      Direct rpm install
    ./keepalived.sh [host_group]    [interface]             [vip]             <on>
    ./keepalived.sh  masters        eth0                    10.0.0.1

    uninstall:
    ./keepalived.sh  CLEAR [host_group]
    
EOF
    exit 1
}

clear(){
    ansible -i ${inventory} $1 -m shell -a 'rpm -qa | grep keepalived | xargs rpm -e'
        ansible -i ${inventory} $1 -m shell -a 'rm -rf /etc/keepalived/'
    exit $?
}


start(){
    pre_check
    install_rpm_to_host_group
    configure_keepalived
}


if [ ! -f ${inventory} ];then
    echo "ansible inventory file ${inventory} not found！"
    echo "usage: inventory=/path/inventory ./keepalived.sh"
    exit -1
fi

host_group=$1
interface=$2
vip=$3
drect=$4

# 卸载
if [ "${host_group}" == "CLEAR" -a -n "${interface}" ];then
    clear "${interface}"
fi

# 参数检查
if [ -z "$host_group" -o -z "${vip}" -o -z "${interface}" ];then
    helper
fi



# 安装
start