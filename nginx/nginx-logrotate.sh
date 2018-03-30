#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#

# 当前绝对路径
log_path=$(cd "$(dirname "$0")"; pwd)/logs

log_name='*.log'
save_days=30

# -------------------------------
Date=`date "+%Y%m%d"`

cd ${log_path}
log_list=$(ls -l ${log_name} | awk '{print $NF}')

for file_name in ${log_list}
do
    mv "${file_name}" "${file_name}_${Date}"
    # 清理
    find ${log_path} -mtime +${save_days} -name "${file_name}_*" | xargs rm -f
done

docker exec nginx bash -c 'kill -USR1 `cat /var/run/nginx.pid 2>/dev/null`' || true

# kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
# ${Path}/sbin/nginx -s reload