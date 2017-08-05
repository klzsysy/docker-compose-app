FROM python:2
#   version=1.1
#   author=Sonny
#   release-date="2017-08-05 17:13:31"

ENV METHOD="aes-256-cfb" \
    PORT=9990 \
    PROTOCOL="auth_aes128_md5" \
    OBFS="tls1.2_ticket_auth_compatible"

EXPOSE 9990

RUN cd / && git clone -b manyuser https://github.com/shadowsocksr-backup/shadowsocksr.git 

WORKDIR /shadowsocksr/shadowsocks

COPY entrypoint.sh . 
RUN chmod a+x entrypoint.sh

CMD ["./entrypoint.sh"]
