dir=$(pwd)

sudo apt-get install python3-dev python3-numpy -yf
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev -yf
sudo apt-get install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev -yf
sudo apt-get install libgtk-3-dev -yf

cd opencv
mkdir -p build  && cd build

# Extra CMAKE options
CMAKE_EXTRA=""

# Check CUDA compilation
nvcc --version  &> /dev/null
if [ $? -eq 0 ]; then
    CMAKE_EXTRA="${CMAKE_EXTRA} -D WITH_CUDA=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=7.5 "
fi


cmake -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D WITH_GTK=ON \
      ${CMAKE_EXTRA} \
     ../

[ $? -eq 0 ] && make -j9

[ $? -eq 0 ] && sudo make install

# Verify
[ $? -eq 0 ] && pkg-config --modversion opencv4
[ $? -eq 0 ] && python3 -c "import cv2; print(cv2.__version__)"
