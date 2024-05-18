#!/bin/bash
export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
sudo apt-get install --reinstall gstreamer1.0-tools gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav
rm -rf ~/.cache/gstreamer-1.0/
gst-inspect-1.0 --gst-plugin-path=/usr/lib/aarch64-linux-gnu/gstreamer-1.0
