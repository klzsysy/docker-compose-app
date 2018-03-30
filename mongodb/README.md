# deployment

## 替换防火墙

```sh
systemctl stop firewalld && systemctl disable firewalld
yum install iptables-services -y
systemctl start iptables && systemctl enable iptables
iptables -I INPUT 4 -p tcp -m state --state NEW --dport 27017 -j ACCEPT && service iptables save
systemctl restart docker
```

## 关闭selinux


```bash

docker exec -it mongodb_db_a_1  mongo


rsconf = {
            "_id" : "rs0",
            "members" : [
                    {
                            "_id" : 0,
                            "host" : "10.209.176.193:27017",
                            "priority" : 2
                    },
                    {
                            "_id" : 1,
                            "host" : "10.209.176.194:27017"
                    },
                    {
                            "_id" : 2,
                            "host" : "10.209.176.195:27017"
                    }
            ]
}

rs.initiate(rsconf)

docker exec -it mongodb_db_b_1  mongo
db.getMongo().setSlaveOk()

docker exec -it mongodb_db_c_1  mongo
db.getMongo().setSlaveOk()

```