FROM resin/rpi-raspbian:stretch

ARG opencvVersion=3.3.0
ARG numOfCores=4

RUN apt-get update && apt-get install -y \
    build-essential cmake pkg-config \
    libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev && \
    # Second apt-get install is required in order to have libpng12-dev being installed as libpng-dev
    apt-get install -y \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev \
    libatlas-base-dev gfortran python2.7-dev python3-dev \
    python3-numpy wget unzip

RUN cd && \
    wget -O opencv.zip https://github.com/Itseez/opencv/archive/$opencvVersion.zip && \
    wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/$opencvVersion.zip && \
    unzip opencv.zip && \
    unzip opencv_contrib.zip && \
    rm -rf opencv.zip opencv_contirb.zip




RUN cd ~/opencv-$opencvVersion && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-$opencvVersion/modules \
        -D BUILD_EXAMPLES=ON .. && \
    make -j$numOfCores

RUN cd ~/opencv-$opencvVersion/build && \
    make install && \
    loadconfig
