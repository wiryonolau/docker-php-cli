FROM centos:7

ENV USER_ID=1000 \ 
    GIT_SSL_VERIFY=false

RUN rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm --import https://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7 \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
    
RUN yum update -y \
    && yum install -y php56w php56w-opcache php56w-mcrypt php56w-pdo php56w-bcmath php56w-gd php56w-intl php56w-ldap php56w-mbstring php56w-pecl-memcached php56w-xml php56w-mysqlnd git \
    && yum install -y ca-certificates curl \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod 755 /usr/local/bin/composer

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && yum clean all \
    && rm -rf /var/cache/yum/*

COPY entrypoint /
RUN chmod 755 /entrypoint

ENTRYPOINT ["/entrypoint"]
CMD ["php", "-a"]
