# mongodb 分片集群初始化

在三台机器上启动docker-compose之后，使用下方参数初始化集群

## shared

    # 注意不能在仲裁节点上激活，否则报错：
    # “with _id 0 is not electable under the new configuration version 1 for replica set xx”
    
    # 分别创建三个副本集：
    # 分别连接到属于不同副本集的主机

    mongo 127.0.0.1:22001
    use admin
  
    config = { _id:"shard1", members:[
                         {_id:0,host:"10.182.22.172:22001"},
                         {_id:1,host:"10.182.22.173:22001"},
                         {_id:2,host:"10.182.22.212:22001",arbiterOnly:true}
                    ]
             }
             
    rs.initiate(config)
    
    # --------
    
    mongo 127.0.0.1:22003
    use admin
    config = { _id:"shard2", members:[
                         {_id:0,host:"10.182.22.172:22002",arbiterOnly:true},
                         {_id:1,host:"10.182.22.173:22002"},
                         {_id:2,host:"10.182.22.212:22002"}
                    ]
             }
    rs.initiate(config)
    
    # --------
    
    mongo 127.0.0.1:22003
    use admin

    config = { _id:"shard3", members:[
                         {_id:0,host:"10.182.22.172:22003"},
                         {_id:1,host:"10.182.22.173:22003"},
                         {_id:2,host:"10.182.22.212:22003",arbiterOnly:true}
                    ]
             }
    rs.initiate(config)
    
    
    rs.status()


## confsrv
    mongo 127.0.0.1:21000
    use admin
    
    rs.initiate({_id:"cfgReplSet",configsvr:true,members:[
                    {_id:0,host:"10.182.22.172:21000"},
                    {_id:1,host:"10.182.22.173:21000"},
                    {_id:2,host:"10.182.22.212:21000"}
                ]
        })
    rs.status()



## mongos
    mongo 127.0.0.1:27017
    use admin
    
    sh.addShard("shard1/10.182.22.172:22001");
    sh.addShard("shard2/10.182.22.173:22002");
    sh.addShard("shard3/10.182.22.212:22003");
    
    查看状态
    sh.status()
    db.runCommand({listShards:1})

---

## mongo 副本集额外配置

    $ docker exec -it mongo_db_1  mongo  10.182.22.172:27017
    rsconf = {
                "_id" : "rs0",
                "members" : [
                        {
                                "_id" : 0,
                                "host" : "10.182.22.172:27017"
                                "priority" : 2
                        },
                        {
                                "_id" : 1,
                                "host" : "10.182.22.173:27017"
                        },
                        {
                                "_id" : 2,
                                "host" : "10.182.22.212:27017"
                        }
                ]
    }


    rs.initiate(rsconf)

    # 使副本可读
    docker exec -it mongo_db_1  mongo  10.182.22.173:27017
    db.getMongo().setSlaveOk()
    exit

    docker exec -it mongo_db_1  mongo  10.182.22.212:27017
    db.getMongo().setSlaveOk()

