# Kube Cloud
#
# Docker Ansible for tests Dockerfile
# https://github.com/kube-cloud/docker-ansible-test
# https://github.com/kube-cloud/docker-ansible-test.git
# git@github.com:kube-cloud/docker-ansible-test.git
#

# Pull base image.
FROM centos:6

# Maintainer
LABEL maintainer="Jean-Jacques ETUNÈ NGI<jetune@kube-cloud.com>"

# Build Date argument
ARG BUILD_DATE

# Version Control REF
ARG VCS_REF

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

# Python version
ENV PY_VERSION=3.6.8

# Python directory filename
ENV PY_DIR_FILENAME=Python-${PY_VERSION}

# Python URL
ENV PY_URL=https://www.python.org/ftp/python/${PY_VERSION}/${PY_DIR_FILENAME}.tgz

# Python downloaded dir
ENV PY_DOWNLOADED_DIR=/tmp/python

# PIP filename
ENV PIP_FILE_NAME=get-pip.py

# PIP URL
ENV PIP_URL=https://bootstrap.pypa.io/get-pip.py

# Pip package to be installed
ENV pip_packages="ansible molecule flake8 testinfra==3.0.5 ansible-lint"

# Install requirements tools.
RUN	yum makecache fast && \
	
	# Used for accelerate package install and update by downloading delta instead if all package
	yum -y install deltarpm && \
	
	# Used by pip to install some packages
	yum -y install gcc && \
	
	# Install openssl devel
	yum -y install openssl-devel && \
	
	# Install bzip2 devel
	yum -y install bzip2-devel && \
	
	# Insall sudo
	yum -y install sudo && \
	
	# Used to make available pip package
	yum -y install epel-release && \
	
	# used to initialize many part of OS (boot, network interfaces, etc...)
	yum -y install initscripts && \
	
	# Install wget
	yum -y install wget && \
	
	# Install Zip
	yum -y install zip && \
	
	# Install Unzip
	yum -y install unzip && \
	
	# Update system
	yum -y update

# Download python
RUN mkdir -p ${PY_DOWNLOADED_DIR} && \
	wget ${PY_URL} -O ${PY_DOWNLOADED_DIR}/${PY_DIR_FILENAME}.tgz && \
	wget ${PIP_URL} -O ${PY_DOWNLOADED_DIR}/${PIP_FILE_NAME}

# Uncompress Python 3.6
RUN	tar xzf ${PY_DOWNLOADED_DIR}/${PY_DIR_FILENAME}.tgz -C ${PY_DOWNLOADED_DIR}
	
# Install python27 framework
RUN	cd ${PY_DOWNLOADED_DIR}/${PY_DIR_FILENAME} && ./configure --enable-optimizations && make altinstall

# nIstall pip
RUN /usr/local/bin/python3.6 ${PY_DOWNLOADED_DIR}/${PIP_FILE_NAME}

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