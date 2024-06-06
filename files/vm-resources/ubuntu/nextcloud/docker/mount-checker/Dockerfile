FROM debian:stable

# Copy the script into the container
COPY check_mountpoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/check_mountpoint.sh

# Run the script
ENTRYPOINT ["/usr/local/bin/check_mountpoint.sh"]
