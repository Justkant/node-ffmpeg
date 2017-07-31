FROM node:8.2-alpine
MAINTAINER Quentin Jaccarino <quentin@tracktl.com>

RUN apk update && apk add ffmpeg && rm -rf /var/cache/apk/*