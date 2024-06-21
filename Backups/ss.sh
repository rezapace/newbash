#!/bin/bash
/usr/bin/flameshot gui -p /tmp --raw | xclip -selection clipboard -t image/png

