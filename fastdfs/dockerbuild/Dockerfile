FROM alpine:3.6

WORKDIR /fastdfs

# 下载fastdfs、libfastcommon、nginx插件的源码
ADD     *.tar.gz *.sh /fastdfs/

ENV     WORK=/fastdfs \
        NGINX_VERSION='1.13.8' \
        HTTP_SERVER_PORT=8080 \
        STORAGE_PORT=23000 \
        BASE_PATH='/var/local/fdfs' \
        PATH=/fastdfs:${PATH}

RUN     apk update && apk add --no-cache --virtual .build-deps bash gcc libc-dev make \
        openssl-dev pcre-dev zlib-dev linux-headers curl gnupg libxslt-dev gd-dev geoip-dev \
        && cd ${WORK}/libfastcommon-1.0.36/ \
        && ./make.sh \
        && ./make.sh install \
        && \
        cd ${WORK}/fastdfs-5.11/ \
        && ./make.sh \
        && ./make.sh install \
        && \ 
        cd /etc/fdfs/ \
        && cp storage.conf.sample storage.conf \
        && cp tracker.conf.sample tracker.conf \
        && cp client.conf.sample client.conf \
        && sed -i "s|/home/yuqing/fastdfs|${BASE_PATH}/tracker|g" /etc/fdfs/tracker.conf \
        && sed -i "s|/home/yuqing/fastdfs|${BASE_PATH}/storage|g" /etc/fdfs/storage.conf \
        && sed -i "s|/home/yuqing/fastdfs|${BASE_PATH}/storage|g" /etc/fdfs/client.conf \
        # 设置nginx和fastdfs联合环境，并配置nginx
        && cd ${WORK} \
        && chmod u+x ${WORK}/fastdfs-nginx-module-master/src/config \
        && cd nginx-${NGINX_VERSION} \
        && ./configure --add-module=${WORK}/fastdfs-nginx-module-master/src \
        && make && make install \
        && \
        cp ${WORK}/fastdfs-nginx-module-master/src/mod_fastdfs.conf /etc/fdfs/ \
        && sed -i "s|^store_path0.*$|store_path0=/var/local/fdfs/storage|g" /etc/fdfs/mod_fastdfs.conf \
        && sed -i "s|^url_have_group_name =.*$|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf \
        && cd ${WORK}/fastdfs-5.11/conf/ \
        && cp http.conf mime.types anti-steal.jpg /etc/fdfs/ \
        && \
        # clear && mkdir && rename
        cd ${WORK} && rm -rf `ls -l  ${WORK} | grep '^d' | awk '{print \$NF}'`; \ 
        apk del .build-deps gcc libc-dev make openssl-dev \
        linux-headers curl gnupg libxslt-dev gd-dev geoip-dev && \
        apk add bash pcre-dev zlib-dev ;\
        mkdir -p ${BASE_PATH}/tracker && \
        mkdir -p ${BASE_PATH}/storage && \
        mv tracker.sh tracker && \
        mv storage.sh storage && \
        rm -f build_docker.sh && \
        chmod a+x *

COPY    nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 22122 23000 8080

CMD tracker