FROM jenkins/jenkins:latest

LABEL maintainer="Wilson Wang <wilson.wang@bytedance.com>"

USER root

ARG TIMEZONE="America/Los_Angeles"
ARG KEYSTORE_PASS="Hq=9.cu,qVVy}5~)"
ARG ROOT_PASS="q8xUY/xV8VM}6T<@"

# change root password
RUN echo "root:${ROOT_PASS}" | chpasswd

# setup timezone
ENV TZ=${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -yq wget vim procps
RUN apt-get install -yq perl libnet-ssleay-perl openssl \
    libauthen-pam-perl libpam-runtime libio-pty-perl \
    python unzip

RUN apt-get -qy install python3 python3-pip
RUN pip3 install docker

# install webmin required apt-show-versions
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get purge apt-show-versions
RUN rm /var/lib/apt/lists/*lz4
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get install -yq apt-show-versions

# Make sure the package repository is up to date.
RUN apt-get install -yq npm && \
    npm install --global smee-client

RUN git clone https://github.com/wilsonwang371/pysmee.git && \
    cd pysmee && \
    python3 ./setup.py install && \
    cd - && rm -rf pysmee

RUN wget http://prdownloads.sourceforge.net/webadmin/webmin_1.990_all.deb
RUN dpkg --install webmin_1.990_all.deb

ENV KSPASS=${KEYSTORE_PASS}
#setup secure ssl
RUN mkdir -p /etc/ssl
RUN yes | keytool -genkey -keyalg RSA -alias selfsigned \
    -storepass "${KSPASS}" \
    -keystore /etc/ssl/jenkins_keystore.jks -keysize 4096 -noprompt

COPY scripts/start.sh /usr/local/bin/start.sh

# for jenkins, we only accept ssl connection
ENTRYPOINT /usr/local/bin/start.sh --httpPort=-1 --httpsPort=8443 \
    --httpsKeyStorePassword="${KSPASS}" \
    --httpsKeyStore=/etc/ssl/jenkins_keystore.jks

USER jenkins
