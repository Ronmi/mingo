FROM debian:stable-slim as builder

ADD build.sh /usr/bin/
ADD deps.sh /usr/bin/
RUN apt-get update && apt-get install -y wget && mkdir -p /build/img
WORKDIR /build
RUN /usr/bin/build.sh



FROM scratch
MAINTAINER Ronmi Ren <ronmi.ren@gmail.com>
COPY --from=builder /build/img /
