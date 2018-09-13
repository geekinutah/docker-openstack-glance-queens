FROM ubuntu:latest
MAINTAINER Mike Wilson <geekinutah@gmail.com>

ENV TERM=xterm-256color

COPY openrc.j2 /openrc.j2

RUN apt-get -q update >/dev/null \
  && apt-get install -y python python-dev curl build-essential git libssl-dev libmysqlclient-dev \
  && git clone --branch stable/queens https://github.com/openstack/glance.git \
  && curl https://bootstrap.pypa.io/get-pip.py | python \
  && pip install glance/ \
  && pip install mysqlclient \
  && pip install PyMySQL \
  && pip install Jinja \
  && mkdir -p /etc/glance/metadefs \
  # Cleanup
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ 

COPY etc_glance/ /etc/glance
COPY etc_glance/metadefs/ /etc/glance/metadefs/
COPY start_glance.sh /usr/bin/start_glance.sh

ENTRYPOINT ["/usr/bin/start_glance.sh"]
