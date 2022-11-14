#
#ARG ENABLE_PROXY=false
#
## Build Apache APISIX
#FROM api7/apisix-base:1.21.4.1.2
#
#ARG APISIX_VERSION=2.99.0
#LABEL apisix_version="${APISIX_VERSION}"
#
#ARG ENABLE_PROXY
#RUN set -x \
#    && (test "${ENABLE_PROXY}" != "true" || /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories) \
#    && apk add --no-cache --virtual .builddeps \
#        build-base \
#        automake \
#        autoconf \
#        make \
#        libtool \
#        pkgconfig \
#        cmake \
#        unzip \
#        curl \
#        openssl \
#        git \
#        openldap-dev \
#    && luarocks install https://github.com/apache/apisix/raw/master/rockspec/apisix-${APISIX_VERSION}-0.rockspec --tree=/usr/local/apisix/deps PCRE_DIR=/usr/local/openresty/pcre \
#    && cp -v /usr/local/apisix/deps/lib/luarocks/rocks-5.1/apisix/${APISIX_VERSION}-0/bin/apisix /usr/bin/ \
#    && (function ver_lt { [ "$1" = "$2" ] && return 1 || [ "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]; };  if [ "$APISIX_VERSION" = "master" ] || ver_lt 2.2.0 $APISIX_VERSION; then echo 'use shell ';else bin='#! /usr/local/openresty/luajit/bin/luajit\npackage.path = "/usr/local/apisix/?.lua;" .. package.path'; sed -i "1s@.*@$bin@" /usr/bin/apisix ; fi;) \
#    && mv /usr/local/apisix/deps/share/lua/5.1/apisix /usr/local/apisix \
#    && apk del .builddeps \
#    && apk add --no-cache \
#        bash \
#        curl \
#        libstdc++ \
#        openldap \
#        tzdata \
#    # forward request and error logs to docker log collector
#    && ln -sf /dev/stdout /usr/local/apisix/logs/access.log \
#    && ln -sf /dev/stderr /usr/local/apisix/logs/error.log
#
#WORKDIR /usr/local/apisix
#
#COPY ./plugins/cognito-auth.lua /usr/local/apisix/plugins/
#
#ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin
#
#EXPOSE 9080 9443
#
#CMD ["sh", "-c", "/usr/bin/apisix init && /usr/bin/apisix init_etcd && /usr/local/openresty/bin/openresty -p /usr/local/apisix -g 'daemon off;'"]
#
#STOPSIGNAL SIGQUIT
#
#
#ARG ENABLE_PROXY=false

# Build Apache APISIX
FROM api7/apisix-base:1.21.4.1.1

ARG APISIX_VERSION=2.15.0
LABEL apisix_version="${APISIX_VERSION}"

ARG ENABLE_PROXY
RUN set -x \
    && (test "${ENABLE_PROXY}" != "true" || /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories) \
    && apk add --no-cache --virtual .builddeps \
        build-base \
        automake \
        autoconf \
        make \
        libtool \
        pkgconfig \
        cmake \
        unzip \
        curl \
        openssl \
        git \
        openldap-dev \
    && luarocks install https://github.com/apache/apisix/raw/master/rockspec/apisix-${APISIX_VERSION}-0.rockspec --tree=/usr/local/apisix/deps PCRE_DIR=/usr/local/openresty/pcre \
    && cp -v /usr/local/apisix/deps/lib/luarocks/rocks-5.1/apisix/${APISIX_VERSION}-0/bin/apisix /usr/bin/ \
    && (function ver_lt { [ "$1" = "$2" ] && return 1 || [ "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]; };  if [ "$APISIX_VERSION" = "master" ] || ver_lt 2.2.0 $APISIX_VERSION; then echo 'use shell ';else bin='#! /usr/local/openresty/luajit/bin/luajit\npackage.path = "/usr/local/apisix/?.lua;" .. package.path'; sed -i "1s@.*@$bin@" /usr/bin/apisix ; fi;) \
    && mv /usr/local/apisix/deps/share/lua/5.1/apisix /usr/local/apisix \
    && apk del .builddeps \
    && apk add --no-cache \
        bash \
        curl \
        libstdc++ \
        openldap \
        tzdata \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /usr/local/apisix/logs/access.log \
    && ln -sf /dev/stderr /usr/local/apisix/logs/error.log

WORKDIR /usr/local/apisix

COPY ./plugins/cognito-auth.lua /usr/local/apisix/apisix/plugins/

ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

EXPOSE 9080 9443

CMD ["sh", "-c", "/usr/bin/apisix init && /usr/bin/apisix init_etcd && /usr/local/openresty/bin/openresty -p /usr/local/apisix -g 'daemon off;'"]

STOPSIGNAL SIGQUIT