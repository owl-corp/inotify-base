FROM alpine:3.20

# Add inotify-tools for inotifywait
#
# We also install curl as scripts using this image often
# call HTTP webhooks.
RUN apk add --no-cache curl inotify-tools jq

# Set our working directory
WORKDIR /app

# Copy the reloader script into the working directory
COPY monitor.sh .

# Set the default command to run the reloader script
CMD ["/app/monitor.sh"]
