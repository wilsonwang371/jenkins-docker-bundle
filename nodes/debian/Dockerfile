FROM quay.io/pypa/manylinux_2_24_x86_64

LABEL maintainer="Wilson Wang <wilson.wang@bytedance.com>"

ARG TIMEZONE="America/Los_Angeles"
ENV TZ=${TIMEZONE}
ENV DEBIAN_FRONTEND=noninteractive

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 (latest stable edition at 2019-04-01)
    apt-get install -qy openjdk-8-jdk && \
# Install maven
    apt-get install -qy maven && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    useradd -m jenkins -p "jenkins" -U -s /bin/bash && \
    mkdir -p /home/jenkins/.m2

RUN apt-get -qy install python3 python3-pip
RUN pip3 install docker

# install node.js and useful packages
ENV NODE_VERSION=14
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
SHELL ["/bin/bash", "-c"]
RUN source /root/.nvm/nvm.sh && \
    nvm install "${NODE_VERSION}" && \
    nvm use "${NODE_VERSION}" && \
    npm install --global smee-client

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
