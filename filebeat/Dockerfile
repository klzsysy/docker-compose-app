FROM debian:jessie

COPY "./filebeat-5.5.0-linux-x86_64" /filebeat
WORKDIR  /filebeat

CMD ["./filebeat", "-e" ,"filebeat.yml"]
