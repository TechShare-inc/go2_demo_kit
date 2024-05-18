#!/bin/bash
# install vscode
wget https://update.code.visualstudio.com/latest/linux-deb-arm64/stable -O code_arm64.deb
sudo dpkg -i code_arm64.deb
sudo apt-get install -f
rm code_arm.deb
