#!/bin/bash

# Test running from regular disk
echo "Running from /opt:"
time (
  local current_dir="$PWD"
  cd /opt
  sudo -E ./cursor.appimage --no-sandbox "$current_dir"
)

# Test running from RAM disk
echo "Running from /tmp/ramdisk:"
time (
  local current_dir="$PWD"
  cd /tmp/ramdisk
  sudo -E ./cursor.appimage --no-sandbox "$current_dir"
)
