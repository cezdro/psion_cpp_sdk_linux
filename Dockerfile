FROM docker.io/ubuntu:20.04

RUN rm -f /etc/apt/apt.conf.d/docker-clean                    \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
      >/etc/apt/apt.conf.d/keep-cache                         \
 && dpkg --add-architecture i386                              \
  ;

WORKDIR /opt/sdk/install

COPY install/clean.sh                        \
     install/cpp.zip                         \
     install/gcc-3.0-psion-98r2-9-patch      \
     install/gcc-3.0-psion-98r2-9-src.tar.gz \
     install/gnupoc.er5.patch.011-patch      \
     install/gnupoc.er5.patch.011.tar.gz     \
     install/install.sh                      \
     install/sdk2unix-1.9-patch              \
     install/sdk2unix-1.9.tar.gz             \
     .

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked     \
    apt-get update                                              \
 && apt-get --yes --no-install-recommends install               \
      bison                                                     \
      build-essential                                           \
      flex                                                      \
      g++-multilib                                              \
      gcc-multilib                                              \
      patch                                                     \
      unzip                                                     \
      zip                                                       \
      zlib1g-dev                                                \
  ;

RUN mkdir -p /root/.wine/dosdevices \
 && ./install.sh                    \
 && cd ..                           \
 && rm -rf install                  \
  ;

WORKDIR /opt/sdk
