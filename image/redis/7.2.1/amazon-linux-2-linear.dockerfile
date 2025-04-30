# Use this source OCI image.
FROM sloopstash/base:v1.1.1

# Set Working directory
WORKDIR /tmp

# Download redis and extract the package
RUN wget http://download.redis.io/releases/redis-7.2.1.tar.gz \
  && tar xvzf redis-7.2.1.tar.gz

# Switch Working directoruy
WORKDIR redis-7.2.1

# Compile and insytall redis
RUN	make distclean \
  && make \ 
  && make install