#!/bin/bash
cd ~/
git clone https://github.com/AprilRobotics/apriltag.git
cd apriltag
mkdir build
cd build
cmake ..
make
sudo make install
