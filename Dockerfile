FROM debian:stable-slim as builder

ARG REPO http://deb.debian.org/debian
ARG ARCH amd64

ADD build.sh /usr/bin/
ADD deps.sh /usr/bin/
RUN apt-get update && apt-get install -y wget && mkdir -p /build/img
WORKDIR /build
RUN /usr/bin/build.sh



FROM scratch
MAINTAINER Ronmi Ren <ronmi.ren@gmail.com>
COPY --from=builder /build/img /
