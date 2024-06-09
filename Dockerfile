FROM debian:12-slim

# Add inotify-tools for inotifywait
#
# We also install curl as scripts using this image often
# call HTTP webhooks.
RUN apt-get -y update &&  apt-get install -y \
    curl \
    inotify-tools \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

# Set our working directory
WORKDIR /app

# Copy the reloader script into the working directory
COPY monitor.sh .

# Set the default command to run the reloader script
CMD ["/app/monitor.sh"]
