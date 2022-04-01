# jenkins-docker-agent

Dokcer agent integration for Jenkins is explained in this article. https://devopscube.com/docker-containers-as-build-slaves-jenkins/

## Build

```bash
# generate a local image named: jenkins-server, jenkins-node-centos and jenkins-node-debian
./build.sh

# or build one of the images:
./build.sh [server | node-centos | node-debian]
```

## Jenkins Server

Jenkins server is based on the jenkins/jenkins docker image. In addition, several useful packages are installed.

- Smee
- Webmin

## Run

```bash
# run jenkins server
docker network create jenkins

mkdir -p $(pwd)/jenkins-data

docker container run --name jenkins \
  --detach --restart unless-stopped \
  --network jenkins \
  --user root \
  --volume $(pwd)/jenkins-data:/var/jenkins_home \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --publish 8443:8443 --publish 50000:50000 \
  --publish 10000:10000 \
  jenkins-server:latest
```

## Q&A

- Q: Self-signed certificate page cannot be opend by Chrome/Edge. A: you can use the "thisisunsafe" trick.
