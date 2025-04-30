# Selecting the base image for docker
FROM sloopstash/base:v1.1.1 AS install_redis

# set working directory
WORKDIR tmp

# Download redis file
RUN wget http://download.redis.io/releases/redis-7.2.1.tar.gz \
  && tar xvzf redis-7.2.1.tar.gz

# Set working directory to install redis
WORKDIR redis-7.2.1

#Compile and install redis
RUN make distclean \
  && make \
  && make install

# Using base image to copy the binary values to multi-stage image
FROM sloopstash/base:v1.1.1 AS copy_binarys

# Copy the binarys from lienar to mutistage image
copy --from=install_redis /usr/local/bin/redis-server /usr/local/bin/redis-server
copy --from=install_redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli

