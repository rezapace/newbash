#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <command>"
  exit 1
fi
mate-terminal -e "sudo bash -c '$*'"
