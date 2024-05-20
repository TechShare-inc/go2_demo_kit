#!/bin/bash
cd ../unitree_ros2/cyclonedds_ws/src/
git clone https://github.com/ros2/rmw_cyclonedds -b foxy
git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.10.x 
#git clone https://github.com/ros2/rosidl.git
cd ..
sudo apt update
sudo apt install ros-foxy-rmw-cyclonedds-cpp
sudo apt install ros-foxy-rosidl-generator-dds-idl
# sudo apt install ros-foxy-performance-test-fixture
colcon build --packages-select cyclonedds
source /opt/ros/foxy/setup.bash
# colcon build --packages-select rmw_cyclonedds_cpp
# colcon build --packages-select rosidl_pycommon
# colcon build --packages-select unitree_api
# colcon build --packages-select unitree_go
colcon build
