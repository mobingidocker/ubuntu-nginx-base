FROM ubuntu:14.04
MAINTAINER sawanoboriyu@higanworks.com

RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl supervisor openssh-server \
  build-essential git curl sqlite3 supervisor libpq-dev \
  libmysqlclient-dev postgresql libpq-dev mysql-client libsqlite3-dev

RUN mkdir -p /var/log/supervisor /var/run/sshd
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN echo deb http://nginx.org/packages/mainline/ubuntu/ `lsb_release -cs` nginx > /etc/apt/sources.list.d/nginx.list

# nginx config
RUN apt-get update && apt-get install -y nginx
ADD nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf
ADD config /config
ADD sudoers /etc/sudoers
ADD run.sh /run.sh

ONBUILD ADD provision.sh /provision.sh
ONBUILD ADD startup.sh /startup.sh
ONBUILD ADD nginx.conf /etc/nginx/conf.d/app.conf
ONBUILD ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ONBUILD RUN chmod +x /*.sh
CMD ["/bin/bash"]
