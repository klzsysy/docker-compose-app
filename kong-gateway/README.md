# Kong API Gateway



## 部署步骤

1. 启动database并等待就绪，`cd database && docker-compose up -d && cd -`

   > 首次运行出现日志 _Created default superuser role 'cassandra'_ 即就绪

2. 待数据库就绪后，初始化数据库 database-prepare，等待完成自动退出 `cd database-prepare && docker-compose up && docker-compose down && cd -` ，只需要初始化一次

3. 数据库初始化完成后，启动kong本体，`cd kong && docker-compose up -d && cd -`

4. 启动dashboard `cd dashboard && docker-compose up -d && cd -`  (可选)

5. 启动面板  `http://localhost:8080` (if set `4`deploy)



## 重要默认值

```sh
    KONG_ADMIN_LISTEN: 0.0.0.0:8001
    KONG_ADMIN_LISTEN_SSL: 0.0.0.0:8444
    KONG_PROXY_LISTEN: 0.0.0.0:8000
    KONG_PROXY_LISTEN_SSL: 0.0.0.0:8443
    dashboard: 8080
    KONG_DASHBOARD_USER: master
    KONG_DASHBOARD_PASSWORD: sonny.klzsysy
```

