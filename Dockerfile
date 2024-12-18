ARG DEBIAN_VERSION=12

FROM debian:${DEBIAN_VERSION}-slim AS build

RUN apt update && \
    apt install -y \
        build-essential \
        python3 \
        pkg-config \
        libglib2.0-dev \
        libxml2-dev \
        zlib1g-dev \
        git \
        ninja-build

WORKDIR /opt

ARG MESON_VERSION=main

RUN git clone --depth=1 --branch=${MESON_VERSION} \
        https://github.com/mesonbuild/meson

WORKDIR /tmp/src

ARG ARAVIS_VERSION=main

RUN git clone --depth=1 --branch=${ARAVIS_VERSION} \
        https://github.com/AravisProject/aravis

WORKDIR /tmp/src/aravis

RUN mkdir -p /tmp/install /tmp/build && \
    python3 /opt/meson/meson.py --prefix=/tmp/install /tmp/build && \
    ninja -C /tmp/build install

FROM debian:${DEBIAN_VERSION}-slim

RUN apt update && \
    apt install -y --no-install-recommends \
        ca-certificates \
        libglib2.0-0 \
        libxml2 \
        wget

COPY --from=build /tmp/install /usr/local
RUN ldconfig

COPY lnls-gen-iocsh.sh /usr/local/bin/lnls-gen-iocsh

WORKDIR /mnt

CMD arv-tool-0.8
