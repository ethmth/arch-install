# Use a minimal base image
FROM alpine:latest

# Create a directory and file within the mount point
# RUN mkdir -p /mnt/your_mount_point && echo "This is a test file." > /mnt/your_mount_point/some_file

# Create a script within the Dockerfile to hold the file open
# RUN echo '#!/bin/sh' > /usr/local/bin/hold_file_open.sh \
#     && echo 'exec 3</mnt/your_mount_point/some_file' >> /usr/local/bin/hold_file_open.sh \
#     && echo 'while :; do sleep 60; done' >> /usr/local/bin/hold_file_open.sh \
#     && chmod +x /usr/local/bin/hold_file_open.sh

# Execute the script to hold the file open
# CMD ["tail -f /media/veracrypt1/"]

# CMD ["cd", "/media/veracrypt1/ext", "&&"]

WORKDIR /media/veracrypt1/ext
# CMD ["sh", "-c", "while :; do sleep 60; done"]

CMD ["sh", "-c", "cd /media/veracrypt1/ext && while :; do sleep 60; done"]