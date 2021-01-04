# Kube Cloud
#
# Docker Ansible for tests Dockerfile
# https://github.com/kube-cloud/docker-ansible-test
# https://github.com/kube-cloud/docker-ansible-test.git
# git@github.com:kube-cloud/docker-ansible-test.git
#

# Pull base image.
FROM centos/python-36-centos7:1

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
RUN	yum makecache fast && \

	# Used for accelerate package install and update by downloading delta instead if all package
	yum -y install deltarpm && \

	# Used by pip to install some packages
	yum -y install gcc && \

	# Used to make available pip package
	yum -y install epel-release && \

	# used to initialize many part of OS (boot, network interfaces, etc...)
	yum -y install initscripts && \

	# Update system
	yum -y update && \

	# Install sudo command
	yum -y install sudo && \

	# Install pip framework
	yum -y install python-pip && \

	# Install pip developer tools
	yum -y install python-devel && \

	# Install Zip
	yum -y install zip && \

	# Install Unzip
	yum -y install unzip && \

	# Clean all unused repos and packages
	yum clean all

# Export ENV LC
ENV LC_ALL=C.UTF-8

# Export LANG
ENV LANG=C.UTF-8

# Upgrade pip
RUN pip install --upgrade pip

# Install pip packages
RUN	pip install $pip_packages

# Disable requiretty in sudoer file to permit sudo usage in script, cron or other things than terinal
RUN	sed -i -e 's/^Defaults\s*requiretty/Defaults !requiretty/'  /etc/sudoers

# Create ansible host dir
RUN mkdir -p /etc/ansible

# Configure ansible Local host connexion
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Official CentOS 7 image extension recommendation
VOLUME ["/sys/fs/cgroup"]

# Container start comand
CMD ["/usr/lib/systemd/systemd"]