FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libaio1 \
    libc6 \
    bash \
    wget \
    rpm \
    alien \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Download Oracle Instant Client RPM packages (adjust version if needed)
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2118000/oracle-instantclient-basiclite-21.18.0.0.0-1.x86_64.rpm
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2118000/oracle-instantclient-devel-21.18.0.0.0-1.el8.x86_64.rpm

# Install the RPM packages
RUN alien --to-deb oracle-instantclient-basiclite-21.18.0.0.0-1.x86_64.rpm
RUN alien --to-deb oracle-instantclient-devel-21.18.0.0.0-1.el8.x86_64.rpm
RUN dpkg -i oracle-instantclient-basiclite_21.18.0.0.0-2_amd64.deb
RUN dpkg -i oracle-instantclient-devel_21.18.0.0.0-2_amd64.deb
# RUN rpm -i oracle-instantclient-basiclite-21.18.0.0.0-1.x86_64.rpm
# RUN rpm -i oracle-instantclient-devel-21.18.0.0.0-1.el8.x86_64.rpm

# Set the environment variables for Oracle Instant Client
ENV LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib:$LD_LIBRARY_PATH
ENV PATH=$PATH:/usr/lib/oracle/21/client64/bin

# Configure and install OCI8

RUN docker-php-ext-configure oci8 --with-oci8=/usr/lib/oracle/21/client64
RUN C_INCLUDE_PATH=/usr/include/oracle/21/client64 docker-php-ext-install oci8

# Add Adminer
RUN wget https://github.com/vrana/adminer/releases/download/v5.2.1/adminer-5.2.1.php -O /var/www/html/index.php

EXPOSE 80
