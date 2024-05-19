#!/bin/bash

# .bashrcファイルのパスを指定
BASHRC_FILE="$HOME/.bashrc"
TMP_FILE="$HOME/.bashrc.tmp"

# 最後の行を読み込む
LAST_LINE=$(tail -n 1 "$BASHRC_FILE")

# 最後の行が "source /opt/ros/foxy/setup.bash" である場合、コメントアウトする
if [ "$LAST_LINE" == "source /opt/ros/foxy/setup.bash" ]; then
    # コメントアウトするためにファイルに書き込み
    echo "# $LAST_LINE" >> "$TMP_FILE"
    # それ以外の行を新しいファイルにコピー
    sed '$d' "$BASHRC_FILE" >> "$TMP_FILE"
    # 古いファイルと新しいファイルを置き換える
    mv "$TMP_FILE" "$BASHRC_FILE"
    echo "The line 'source /opt/ros/foxy/setup.bash' has been commented out."
else
    echo "The line 'source /opt/ros/foxy/setup.bash' was not found as the last line in $BASHRC_FILE."
fi
