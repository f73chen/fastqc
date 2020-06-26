FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY fastqc_recipe.yaml /modulator/code/gsi/recipe.yaml

# build the modules and set folder & file permissions
RUN ./build-local-code /modulator/code/gsi/recipe.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
COPY .bashrc /home/ubuntu/.bashrc

# set environment paths for modules
#ENV FASTQC_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/fastqc-0.11.8"
#ENV JAVA_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/java-8"
#ENV PERL_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/perl-5.30"

#ENV PATH="/modules/gsi/modulator/sw/Ubuntu18.04/fastqc-0.11.8/bin:/modules/gsi/modulator/sw/Ubuntu18.04/java-8/bin:/modules/gsi/modulator/sw/Ubuntu18.04/perl-5.30/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#ENV MANPATH="/modules/gsi/modulator/sw/Ubuntu18.04/java-8/man:/modules/gsi/modulator/sw/Ubuntu18.04/perl-5.30/share/man"
#ENV LD_LIBRARY_PATH="/modules/gsi/modulator/sw/Ubuntu18.04/java-8/lib:/modules/gsi/modulator/sw/Ubuntu18.04/perl-5.30/lib"
#ENV PERL5LIB="/modules/gsi/modulator/sw/Ubuntu18.04/perl-5.30/lib/site_perl"

CMD /bin/bash
