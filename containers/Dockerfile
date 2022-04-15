FROM debian:buster

VOLUME /root
#VOLUME /data

RUN apt update
RUN apt install -y libapr1 libaprutil1 libpcre2-dev libevent-dev build-essential time bc flex bison libacl1 libssl1.1 libssl-dev

ENTRYPOINT [ "/root/docker.sh" ]
