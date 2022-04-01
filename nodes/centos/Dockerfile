FROM quay.io/pypa/manylinux2014_x86_64

LABEL maintainer="Wilson Wang <wilson.wang@bytedance.com>"

ARG TIMEZONE="America/Los_Angeles"
ENV TZ=${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Make sure the package repository is up to date.
RUN yum update && \
    yum install -q -y git && \
# Install a basic SSH server
    yum install -q -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 (latest stable edition at 2019-04-01)
    yum install -q -y java-1.8.0-openjdk.x86_64 && \
# Install maven
    yum install -q -y maven && \
# Cleanup old packages
    yum -q -y autoremove && \
# Add user jenkins to the image
    adduser -m jenkins -p "jenkins" -U -s /bin/bash && \
    mkdir /home/jenkins/.m2

RUN yum install -q -y python3 python3-pip
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
