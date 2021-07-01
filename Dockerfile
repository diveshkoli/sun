FROM centos:8
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
RUN yum install docker -y
VOLUME ["/opt/volume"]
EXPOSE 22
CMD ["docker --version"]
