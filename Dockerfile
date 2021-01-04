# Kube Cloud
#
# Docker Ansible for tests Dockerfile
# https://github.com/kube-cloud/docker-ansible-test
# https://github.com/kube-cloud/docker-ansible-test.git
# git@github.com:kube-cloud/docker-ansible-test.git
#

# Pull base image.
FROM centos:7

# Maintainer
LABEL maintainer="Jean-Jacques ETUNÈ NGI<jetune@kube-cloud.com>"

# Build Date argument
ARG BUILD_DATE

# Version Control REF
ARG VCS_REF

# Pip package to be installed
ENV pip_packages "ansible molecule flake8 testinfra ansible-lint"

# Name Label
LABEL org.label-schema.name = "ansible-test"

# Description Label
LABEL org.label-schema.description = "Centos based Docker container image for Ansible Playbook and Role Testing."

# RUL Label
LABEL org.label-schema.url="https://github.com/kube-cloud/docker-ansible-test"

# RUL Label
LABEL org.label-schema.build-date=$BUILD_DATE

# Version control system URL Label
LABEL org.label-schema.vcs-url="https://github.com/rossf7/label-schema-automated-build.git"

# Version control system REF Label
LABEL org.label-schema.vcs-ref=$VCS_REF

# Label Schema Label
LABEL org.label-schema.schema-version="1.0.0-rc.1"

# Official CentOS 7 image extension - systemd usage recommendations : See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements tools.
RUN	yum makecache fast

# Used for accelerate package install and update by downloading delta instead if all package
RUN	yum -y install deltarpm

# Used by pip to install some packages
RUN	yum -y install gcc

# Used to make available pip package
RUN	yum -y install epel-release

# used to initialize many part of OS (boot, network interfaces, etc...)
RUN	yum -y install initscripts

# Update system
RUN	yum -y update

# Install sudo command
RUN	yum -y install sudo

# Install yum utils
RUN	yum -y install yum-utils

# Install IUS Comminuty
RUN	yum -y install https://repo.ius.io/7/x86_64/packages/i/ius-release-2-1.el7.ius.noarch.rpm

# Install Python 3.6
RUN	yum -y install python36u

# Install pip framework
RUN	yum -y install python36u-pip

# Install python developer tools
RUN	yum -y install python36u-devel

# Install python developper libs
RUN	yum -y install python36u-libs

# Install Zip
RUN	yum -y install zip

# Install Unzip
RUN	yum -y install unzip

# Clean all unused repos and packages
RUN	yum clean all

# Install python Link
RUN ln -s /usr/bin/python3.6 /usr/bin/python36

# Upgrade pip
RUN pip3 install --upgrade pip

# Install pip wheel
RUN	pip3 install wheel

# Install pip packages
RUN	pip3 install $pip_packages

# Disable requiretty in sudoer file to permit sudo usage in script, cron or other things than terinal
RUN	sed -i -e 's/^Defaults\s*requiretty/Defaults !requiretty/'  /etc/sudoers

# Create ansible host dir
RUN mkdir -p /etc/ansible

# Configure ansible Local host connexion
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Export LC
ENV LC_ALL=en_US.utf-8

# Export LANG
ENV LANG=en_US.utf-8

# Official CentOS 7 image extension recommendation
VOLUME ["/sys/fs/cgroup"]

# Container start comand
CMD ["/usr/lib/systemd/systemd"]