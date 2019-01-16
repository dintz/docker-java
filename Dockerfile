# AlpineLinux with the GNU C Library, Bash and Oracle Java 8
FROM alpine:3.7

# Versions and constants for the RUN command
ENV GLIBC_VERSION=2.28-r0 \
    JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=191 \
    JAVA_VERSION_BUILD=12 \
    JAVA_PATH=2787e4a523244c269598db4e85c51e0c \
    JAVA_PACKAGE=server-jre \
    JAVA_HOME=/opt/jdk

RUN cd /tmp && \
    # install glibc
    # as discribed in https://github.com/sgerrand/alpine-pkg-glibc
    apk --update --virtual build-dependencies add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    # add bash & curl to container
    apk --update add bash curl && \
    # download JDK
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PATH}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    # setup JDK and remove needless stuff
    mkdir /opt && \
    tar -xzf ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    mv jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} $JAVA_HOME && \
    rm -rf $JAVA_HOME/jre/plugin \
           $JAVA_HOME/jre/bin/javaws \
           $JAVA_HOME/jre/bin/jjs \
           $JAVA_HOME/jre/bin/orbd \
           $JAVA_HOME/jre/bin/pack200 \
           $JAVA_HOME/jre/bin/policytool \
           $JAVA_HOME/jre/bin/rmid \
           $JAVA_HOME/jre/bin/rmiregistry \
           $JAVA_HOME/jre/bin/servertool \
           $JAVA_HOME/jre/bin/tnameserv \
           $JAVA_HOME/jre/bin/unpack200 \
           $JAVA_HOME/jre/lib/javaws.jar \
           $JAVA_HOME/jre/lib/deploy* \
           $JAVA_HOME/jre/lib/desktop \
           $JAVA_HOME/jre/lib/*javafx* \
           $JAVA_HOME/jre/lib/*jfx* \
           $JAVA_HOME/jre/lib/amd64/libdecora_sse.so \
           $JAVA_HOME/jre/lib/amd64/libprism_*.so \
           $JAVA_HOME/jre/lib/amd64/libfxplugins.so \
           $JAVA_HOME/jre/lib/amd64/libglass.so \
           $JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so \
           $JAVA_HOME/jre/lib/amd64/libjavafx*.so \
           $JAVA_HOME/jre/lib/amd64/libjfx*.so \
           $JAVA_HOME/jre/lib/ext/jfxrt.jar \
           $JAVA_HOME/jre/lib/ext/nashorn.jar \
           $JAVA_HOME/jre/lib/oblique-fonts \
           $JAVA_HOME/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/* && \
    apk --update del build-dependencies

COPY bashrc /root/.bashrc

ENV PATH=${PATH}:${JAVA_HOME}/bin

LABEL maintainer="Daniel Wojtucki"
