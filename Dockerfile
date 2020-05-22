FROM ubuntu:18.04

MAINTAINER Fenglin Chen <g3chen@oicr.on.ca>

USER root

# need java-11, gzip (gunzip), and fastqc
RUN apt-get -m update && apt-get install -y gzip openjdk-11-jre fastqc

# copy in fastqc-required scripts calculate.sh and compare.sh into bin
COPY calculate.sh compare.sh /usr/local/bin/

# set required permissions
RUN chmod a+x /usr/local/bin/calculate.sh && chmod a+x /usr/local/bin/compare.sh

# COPY womtool-50.jar cromwell-50.jar /usr/local/bin

RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

CMD [/bin/bash]

