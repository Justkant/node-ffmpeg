FROM node:8.4-alpine
MAINTAINER Quentin Jaccarino <quentin@tracktl.com>

RUN apk update && apk add ffmpeg && rm -rf /var/cache/apk/*