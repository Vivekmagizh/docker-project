# Select the base image to run the container  
# Parallel stage                              
FROM sloopstash/base:v1.1.1 AS install_system_packages

# Install system packages
RUN yum install -y tcl 
#-------------------------------------------------------------------------
# Install redis stage
# Dependent stage (Chained)
FROM install_system_packages AS install_redis                              

# Set working directory
WORKDIR tmp

# Download the redis binary redis program and extract the file
RUN set -x \
  && wget http://download.redis.io/releases/redis-7.2.1.tar.gz --quiet \
  && tar xvzf redis-7.2.1.tar.gz > /dev/null

# Set working directroy 
WORKDIR redis-7.2.1
# Compile and install redis
RUN set -x \
  && make distclean \
  && make \
  && make install
# ------------------------------------------------------------------------- 
# Create Working directories for the redis DB
# Parellel stage
FROM sloopstash/base:v1.1.1 AS create_redis_directories
# Set working directory 
WORKDIR ~/
# Create redis direcories
RUN set -x \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/script \
  && mkdir /opt/redis/system \
  && touch /opt/redis/system/server.pid \
  && touch /opt/redis/system/supervisor.ini 

# Create the final image
FROM sloopstash/base:v1.1.1 AS finalize_redis_oci_image
COPY --from=install_redis /usr/local/bin/redis-server /uer/local/bin/redis-server
COPY --from=install_redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli
COPY --from=create_redis_directories /opt/redis /opt/redis

# Run redis from supervisor
RUN set -x \
  && ln -s /opt/redis/system/supervisor.ini /etc/supervisord.d/redis.ini \
  && history -c

# Set Work directory
WORKDIR /opt/redis





