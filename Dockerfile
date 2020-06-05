FROM ubuntu:focal

ADD scripts/docker_tzdata.sh /docker_tzdata.sh
RUN /docker_tzdata.sh

RUN apt-get install -y net-tools build-essential ninja-build valgrind git cmake autoconf \
    libtool pkg-config rsync openssh-server cppcheck clang-tools clang-tidy clang-format \
    libboost-all-dev ssh iputils-ping vim man \
    nmap lsof postgresql postgresql-contrib redis-server

# configure SSH for communication with Visual Studio
RUN mkdir -p /var/run/sshd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    ssh-keygen -A

WORKDIR /root/workspace

# Unminimize the image so that we can have 'man' etc.
#RUN unminimize

# expose port 22 and 55555 custom port
EXPOSE 22 5432 6379 55555 

CMD ["/usr/sbin/sshd", "-D"]
