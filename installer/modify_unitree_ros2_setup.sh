#!/bin/bash
# 修正対象のファイル
TARGET_FILE="../unitree_ros2/setup.sh"

# 変更箇所
sed -i 's|source $HOME/unitree_ros2/cyclonedds_ws/install/setup.bash|source $HOME/Go2_demo/unitree_ros2/cyclonedds_ws/install/setup.bash|' $TARGET_FILE
sed -i 's|<NetworkInterface name="enp3s0"|<NetworkInterface name="eth0"|' $TARGET_FILE
