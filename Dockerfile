FROM ubuntu:22.04

RUN apt-get update -y && apt-get install openssl

COPY cert_read.sh cert_read.sh

ENTRYPOINT [ "/bin/bash", "cert_read.sh" ]
