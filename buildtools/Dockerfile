# This Dockerfile allowed me to build the 1.0 stylesheets.
# N.B.
#  - You may have to copy this file to the root directory in order for the ADD command to work.
#  - I built it like this:
#    docker build -t xslt10-builder .
#  - You have to mount the 1.0 stylesheet directory when you run it.
#  - I ran it like this:
#    docker run -v /projects/docbook/10xslt:/usr/local/xslt10-stylesheets -it xslt10-builder

FROM ubuntu
MAINTAINER Norman Walsh <ndw@nwalsh.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
RUN apt-get --yes install tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get --yes install apt-file apt-utils
RUN apt-file update
RUN apt-get --yes dist-upgrade
RUN apt-get --yes install xsltproc libxml-xpath-perl libxml2-utils libsaxon-java libxml-commons-resolver1.1-java \
                          libxerces2-java trang imagemagick dblatex
RUN apt-get --yes install make w3m git

RUN adduser --gecos "Docker User,,," --uid 501 --disabled-password docker-user

ADD .travis/xmlc /home/docker-user/.xmlc

ENV CLASSPATH=/usr/share/java/xalan2.jar:/usr/share/java/xercesImpl.jar:/usr/share/java/xml-resolver.jar:/usr/local/xslt10-stylesheets/.travis

VOLUME ["/usr/local/xslt10-stylesheets"]
WORKDIR /usr/local/xslt10-stylesheets

#script:
#- make
#- make check
#- make dist
#- export VERSION=$(make version)

USER docker-user
