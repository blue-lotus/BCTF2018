FROM ubuntu:18.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y lib32z1 libc6-i386 xinetd 
RUN apt-get install -y libstdc++6 lib32stdc++6
RUN apt-get install -y gcc
RUN apt-get install -y python python-pip

RUN pip install pwntools


RUN useradd -m ctf

COPY ./bin/ /home/ctf/
COPY ./ctf.xinetd /etc/xinetd.d/ctf
COPY ./start.sh /start.sh

RUN chmod +x /start.sh
RUN chown -R root:ctf /home/ctf
RUN chmod -R 750 /home/ctf
RUN chmod -R 740 /home/ctf/flag
RUN mkdir /backup
WORKDIR /

CMD ["/start.sh"]

EXPOSE 23334
