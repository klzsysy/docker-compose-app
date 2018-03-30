# mongo 多节点副本集部署

## 前置条件

- docker
- mongo docker 镜像
- docker-compose

## 节点安装

- copy docker compose 配置到各节点
    ```bash
    # 在docker compose目录执行权限修正

    mkdir -p ./db/data
    mkdir -p ./db/log
    sudo chown 999 -R ./db
    ```
- 配置selinux
    ```sh
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g'  /etc/selinux/config
    setenforce 0
    ```
- 配置防火墙
    ```sh
    systemctl is-active firewalld &>/dev/null && firewall-cmd --add-port=27017/tcp --permanent && systemctl restart firewalld
    systemctl is-active iptables &>/dev/null && iptables -I INPUT 4 -p tcp  -m state --state NEW --dport 27017 -j ACCEPT && service iptables save
    ```


## 初始化集群

- 在节点docker compose 目录执行 `docker-compose up -d` 启动mongo节点


- 在第一个节点执行初始化，修改其中的 **HSOT IP**
    ```sh
    docker exec -it mongodb_db_a_1  mongo

    rsconf = {
            "_id" : "rs0",
            "members" : [
                    {
                            "_id" : 0,
                            "host" : "192.195.24.139:27017",
                            "priority" : 2
                    },
                    {
                            "_id" : 1,
                            "host" : "192.195.24.140:27017"
                    },
                    {
                            "_id" : 2,
                            "host" : "192.195.24.141:27017"
                    }
            ]
    }

    rs.initiate(rsconf)
    ```

## 配置机器keepalived 活动IP

- [创建虚拟IP](./ha/README.md)
