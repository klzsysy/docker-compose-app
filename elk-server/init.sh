#!/usr/bin/env bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

change_file_max_limit(){

cat >> /etc/security/limits.conf <<'EOF'
*                soft    nofile          300000
*                hard    nofile          500000
EOF

cat >> /etc/sysctl.conf <<'EOF'
fs.file-max=502400
net.core.somaxconn=20480
net.ipv4.tcp_max_syn_backlog=20480
vm.max_map_count=262144
EOF
sysctl -p

}

change_file_max_limit