# Select the base image
FROM sloopstash/base:v1.1.1 

# Switch directory
WORKDIR ~/

# Install python packages
RUN set -x \
  && yum install -y python-2.7.18 python-devel python-pip python-setuptools

# Install python packages
RUN set -x \
  && pip install flask==0.12.4 \
  && pip install redis==2.10.6 \
  && pip install elastic-apm[flask]==3.0.5

# Create app directories
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/secret \
  && mkdir /opt/app/system \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default working directory
WORKDIR /opt/app


