FROM centos:latest
LABEL maintainer "Satyam Singh"

# Install necessary packages
RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf install -y \
        google-chrome-stable \
        xorg-x11-server-Xvfb \
        x11vnc \
        fluxbox && \
    dnf clean all

# Set environment variable for X11
ENV DISPLAY=:99

# Start Xvfb and VNC server
CMD /usr/bin/Xvfb :99 -screen 0 1920x1080x16 & \
    /usr/bin/fluxbox & \
    /usr/bin/x11vnc -display :99 -nopw -forever -create & \
    google-chrome --no-sandbox
