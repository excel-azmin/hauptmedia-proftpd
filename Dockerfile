# Use a more recent Debian release as the base image
FROM debian:buster

# Set a non-interactive frontend for apt-get to avoid interactive prompts during the build
ENV DEBIAN_FRONTEND=noninteractive

# Install proftpd and clean up in one RUN command to reduce image size
RUN apt-get update -qq && \
    apt-get install -y proftpd && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# Enable DefaultRoot directive to confine users to their home directories
RUN sed -i "s/# DefaultRoot/DefaultRoot/" /etc/proftpd/proftpd.conf

# Expose the FTP ports
EXPOSE 20 21

# Add the entrypoint script
ADD docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/sbin/docker-entrypoint.sh

# Define the entrypoint and default command
ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh"]
CMD ["proftpd", "--nodaemon"]
