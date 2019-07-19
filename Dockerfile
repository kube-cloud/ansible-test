# Kube Cloud
#
# Docker Ansible for tests Dockerfile
# https://github.com/kube-cloud/docker-ansible-test
# https://github.com/kube-cloud/docker-ansible-test.git
# git@github.com:kube-cloud/docker-ansible-test.git
#

# Pull base image.
FROM ubuntu:18.04

# Maintainer
LABEL maintainer="Jean-Jacques ETUNÈ NGI<jetune@kube-cloud.com>"

# Build Date argument
ARG BUILD_DATE

# Version Control REF
ARG VCS_REF

# Pip package to be installed
ENV pip_packages "ansible pyopenssl  molecule flake8 testinfra ansible-lint"

# Name Label
LABEL org.label-schema.name = "ansible-test"

# Description Label
LABEL org.label-schema.description = "Ubuntu based Docker container image for Ansible Playbook and Role Testing."

# RUL Label
LABEL org.label-schema.url="https://github.com/kube-cloud/docker-ansible-test/tree/ubuntu18"

# RUL Label
LABEL org.label-schema.build-date=$BUILD_DATE

# Version control system URL Label
LABEL org.label-schema.vcs-url="git@github.com:kube-cloud/docker-ansible-test.git"

# Version control system REF Label
LABEL org.label-schema.vcs-ref=$VCS_REF

# Label Schema Label
LABEL org.label-schema.schema-version="1.0.0-rc.1"

# Install requirements tools.
RUN	apt-get update && \
	
	# Install Pip 2
	apt-get install -y python-pip && \
	
	# Install Pip for python 3
	apt-get install -y python3-pip && \
	
	# Install wget
	apt-get install -y  wget && \
	
	# Install syslog
	apt-get install -y rsyslog && \
	
	# Install systemd
	apt-get install -y  systemd && \
	
	# Install systemd cron
	apt-get install -y systemd-cron && \
	
	# Install sudo
	apt-get install -y sudo && \
	
	# Install iproute 2
	apt-get install -y iproute2 && \
	
	# Install Zip
	apt-get install -y zip && \
	
	# Install Unzip
	apt-get install -y unzip && \
	
	# Clean apt list
	rm -Rf /var/lib/apt/lists/* && \
	
	# Remove Share and manuals
	rm -Rf /usr/share/doc && rm -Rf /usr/share/man && \
	
	# Clean apt
	apt-get clean
	
# Upgrade pip
RUN pip install --upgrade pip

# Upgrade cryptography
RUN pip install --upgrade cryptography

# Install pip packages
RUN	pip install $pip_packages

# Disable requiretty in sudoer file to permit sudo usage in script, cron or other things than terinal
RUN	sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Create ansible host dir
RUN mkdir -p /etc/ansible

# Configure ansible Local host connexion
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Declare volume for binding
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Container start command
CMD ["/lib/systemd/systemd"]