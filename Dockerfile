FROM debian:stretch-slim

LABEL author="Matt Titmus <matthew.titmus@gmail.com>"
LABEL maintainer="Brannon Dorsey <brannon@brannondorsey.com>"

ENV STORY_ZIP zork1.zip
ENV STORY_DAT DATA/ZORK1.DAT

RUN apt-get update && \
    apt-get install -y frotz sudo unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash frotz

USER frotz
WORKDIR /home/frotz

COPY ${STORY_ZIP} story.zip

RUN unzip story.zip \
   && rm story.zip

# Make a nice, simply-placed save file directory
# We'll need to take root form to manage this.
#
USER root

RUN mkdir /save \
   && chown frotz:frotz /save \
   && chmod 775 /save

# We need to run from here because Frotz drops treats the working directory
# as the save directoy
#
WORKDIR /save
ENV TERM=linux
CMD chgrp frotz /save \
  && chmod 775 /save \
  && sudo -u frotz /usr/games/frotz /home/frotz/${STORY_DAT} | tee /dev/null
