# User Docker specific base image https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:0.9.15
MAINTAINER newlife

# Correct environment variables
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update
RUN apt-get install -y git curl emacs24-nox

WORKDIR /root

# Install https://github.com/bbatsov/prelude
RUN curl -L http://git.io/epre | sh

# Precompile the prelude
RUN emacs --script .emacs.d/init.el

# Set HOME needed for emacs to pick up prelude through /sbin/my_init
RUN echo "/root" > /etc/container_environment/HOME

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system to run emacs as a one-shot process
CMD /sbin/my_init -- /usr/bin/emacs
