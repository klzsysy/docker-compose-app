# 完善部负载均衡器，部署vip

## 资源准备

- 控制机安装ansible
- 一个包含主机组的ansible inventory文件
- 规划一个IP地址作为VIP使用
- 要安装到的目标组还没有安装keepalived软件，否则会覆盖配置
- 确认VIP要绑定的网卡
- 安装的组内至少两台主机

## install

为集群安装后的lb组配置虚拟ip，该组已经自动配置了haproxy的masters api组负载均衡

```bash
# Example: 对masters组做一个VIP
# install

# inventory变量指定inventory位置
inventory=../inventory  ./keepalived.sh lb ens160  172.16.20.4

# uninstall
./keepalived.sh CLEAR lb

```

## 注意事项

- 该脚本只会配置虚拟IP 不会执行其他动作
- check_status.sh 应该根据实际情况修改，通常为检查本机的某个关键应用状态
- keepalived.conf 中的virtual_router_id 参数确保主机所在子网内没有重复，即如果有多组VIP，virtual_router_id 应确保不同，目前是随机生成