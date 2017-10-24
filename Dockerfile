FROM node:8.7-alpine
MAINTAINER Quentin Jaccarino <quentin@tracktl.com>

# The use of apk --no-cache avoids the need to use --update
# and remove /var/cache/apk/* when done installing packages.
# http://gliderlabs.viewdocs.io/docker-alpine/usage/
RUN apk --no-cache add ffmpeg