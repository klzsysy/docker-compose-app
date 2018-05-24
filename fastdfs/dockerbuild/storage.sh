#!/usr/bin/env bash

logs(){
    echo -e "$(date '+%Y-%m-%d %H:%M:%S'): $@"
}
mkdir -p ${BASE_PATH}/storage

TRACKER_SERVERS=

TRACKER_SERVER_LIST=$(env | grep TRACKER_SERVER | awk -F= '{print $2}')

if [ -z "$TRACKER_SERVER_LIST" ];then
    logs "must defin tracker address!"
    logs "use info: https://hub.docker.com/r/klzsysy/fdfs/"
    exit 1
else
    for x in ${TRACKER_SERVER_LIST}
    do
        TRACKER_SERVERS="${TRACKER_SERVERS}\ntracker_server=${x}"
    done
fi
logs tracker list: ${TRACKER_SERVERS}

[ -z "${GROUP_NAME}" ] && GROUP_NAME=group1
[ -z "${GROUP_COUNT}" ] && GROUP_COUNT=1

STORAGE_PATH0=/var/local/fdfs/storage

sed -i "s#^\(port\).*#\1=$STORAGE_PORT#" /etc/fdfs/storage.conf
sed -i "s#^\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/storage.conf
# sed -i "s#^\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/storage.conf
# sed -i "s#^\(store_path0\).*#\1=$STORAGE_PATH0#" /etc/fdfs/storage.conf



sed -i "s#^\(tracker_server\).*#${TRACKER_SERVERS}#" /etc/fdfs/storage.conf
sed -i "s#^\(tracker_server\).*#${TRACKER_SERVERS}#" /etc/fdfs/client.conf

sed -i "s#^\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/storage.conf

# sed -i "s#^\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/mod_fastdfs.conf
# sed -i "s#^\(store_path0\).*#\1=$STORAGE_PATH0#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#^\(storage_server_port\).*#\1=$STORAGE_PORT#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#^\(tracker_server\).*#${TRACKER_SERVERS}#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#^\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#^\(group_count\).*#\1=$GROUP_COUNT#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#listen.*#listen    ${HTTP_SERVER_PORT};#g" /usr/local/nginx/conf/nginx.conf
sed -i "s#^\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#^\(url_have_group_name\).*#\1=true#" /etc/fdfs/mod_fastdfs.conf

# add cuurent groups
echo '# --- apply env $GROUP_NAME ---' >> /etc/fdfs/mod_fastdfs.conf
echo "[${GROUP_NAME}]" >> /etc/fdfs/mod_fastdfs.conf
echo "group_name=${GROUP_NAME}" >> /etc/fdfs/mod_fastdfs.conf
echo "storage_server_port=$STORAGE_PORT" >> /etc/fdfs/mod_fastdfs.conf
# 只有一个路径
echo "store_path_count=1" >> /etc/fdfs/mod_fastdfs.conf
echo "store_path0=$STORAGE_PATH0" >> /etc/fdfs/mod_fastdfs.conf


cd /etc/fdfs
touch mime.types
/usr/local/nginx/sbin/nginx -t
/usr/local/nginx/sbin/nginx

/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart && tail -f /var/local/fdfs/storage/logs/storaged.log

