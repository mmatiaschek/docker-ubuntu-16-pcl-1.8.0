FROM jupyter/minimal-notebook:latest

MAINTAINER Markus Matiaschek <mmatiaschek@gmail.com>

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      make cmake build-essential git \
      libeigen3-dev \
      libflann-dev \
      libusb-1.0-0-dev \
      libvtk6-qt-dev \
      libpcap-dev \
      libboost-all-dev \
      libproj-dev \
      && rm -rf /var/lib/apt/lists/*

RUN \
    git config --global http.sslVerify false && \
    git clone --branch pcl-1.8.0 --depth 1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk && \
    cd pcl-trunk && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && make install && \
    make clean

RUN ldconfig

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID