FROM node:10.15-alpine

# The use of apk --no-cache avoids the need to use --update
# and remove /var/cache/apk/* when done installing packages.
# http://gliderlabs.viewdocs.io/docker-alpine/usage/
RUN apk --no-cache add ffmpeg ca-certificates