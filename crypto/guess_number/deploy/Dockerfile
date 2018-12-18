FROM ubuntu:16.04

COPY ./start.sh /start.sh
COPY /src /guess_number

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
    apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y python socat && \
    apt install -y python-pip libgmp-dev libmpfr-dev libmpc-dev &&\
    pip install gmpy2 &&\
    chmod 755 /start.sh

CMD ["/start.sh"]

EXPOSE 1337
