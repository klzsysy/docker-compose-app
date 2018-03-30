# 多节点集群的单节点配置
# copy file to /data


yum install docker python-pip -y
pip install docker-compose

cat > /etc/docker/daemon.json <<'EOF'
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF

systemctl start docker && systemctl enable docker


mkdir -p mongodb && cd mongodb
mkdir -p ./db/db_a/data
mkdir -p ./db/db_a/log
chown 999 -R ./db
sed -i 's/^SELINUX=.*/SELINUX=disabled/g'  /etc/selinux/config
setenforce 0

cat > docker-compose.yaml <<'EOF'
version: "2"

services:
  db_a:
    image: mongo:3.4
    restart: always
    ports:
      - "27017:27017"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./db/db_a/data:/data/db
      - ./db/db_a/log:/data/log
    command: mongod  --replSet rs0  --dbpath /data/db --port 27017 --logpath /data/log/db.log
EOF

docker-compose up -d

systemctl stop firewalld && systemctl disable firewalld
yum install iptables-services -y
systemctl start iptables && systemctl enable iptables
systemctl restart docker

# 后续事宜README.md中的方法创建副本集