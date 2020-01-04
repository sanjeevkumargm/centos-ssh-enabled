FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# For service command
RUN yum -y install initscripts && yum clean all

RUN yum install -y openssh-server && yum clean all

RUN echo 'root:password' | chpasswd

# Add ansible user
RUN yum install -y sudo && yum clean all
RUN adduser ansible && echo 'ansible:ansible' | chpasswd && usermod -aG wheel ansible
RUN echo "ansible    ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/usr/sbin/init"]
CMD ["/usr/sbin/sshd", "-D"]
