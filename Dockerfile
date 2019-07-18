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

# Install requirements tools.
RUN	yum makecache fast && \
	
	# Used for accelerate package install and update by downloading delta instead if all package
	yum -y install deltarpm && \
	
	# Used by pip to install some packages
	yum -y install gcc && \
	
	# Used to make available pip package
	yum -y install epel-release centos-release-scl && \
	
	# used to initialize many part of OS (boot, network interfaces, etc...)
	yum -y install initscripts && \
	
	# Update system
	yum -y update
	
# Install sudo
RUN	yum -y install sudo
	
# Install python27 framework
RUN	yum -y install python27
	
# Clean all unused repos and packages
RUN	yum clean all

# Install pip packages
RUN	scl enable python27 bash

RUN source /opt/rh/python27/enable && echo $(python -V)

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