# docker build -t pgsql-dev -f pgsql-dev.dockerfile .
# docker run --rm -it -p 5432:5432 --name pgsql-dev -v ${pwd}:/work pgsql-dev
# psql -d dev -U dev (pwd=rei)

FROM ubuntu:bionic

ENV TZ US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y \
        postgresql \
        postgresql-10-pgtap \
        nodejs \
        npm \
        sudo
RUN npm install -g nodemon

RUN echo "host all  all    0.0.0.0/0  md5"    >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'"               >> /etc/postgresql/10/main/postgresql.conf

EXPOSE 5432
WORKDIR work
RUN mkdir -p /cmd \
    && chmod 777 /cmd
ENV PATH /cmd:$PATH
CMD xrad

RUN echo '#!/bin/bash\n\
    if ! pg_isready \n\
    then \n\
        service postgresql start \n\
        while ! pg_isready \n\
        do \n\
            echo "$(date) waiting for database to start" \n\
            sleep 2 \n\
        done \n\
        sleep 2 \n\
    fi \n\
    \n\
    \n\
    sudo -u postgres psql -c "create user dev with superuser password '\''rei'\'';" \n\
    sudo -u postgres psql -c "create database dev;" \n\
    sudo -u postgres psql -d dev -c "create extension if not exists pgtap;" \n\
    sudo -u postgres psql -d dev -c "create schema dev;" \n\
    \n\
    \n\
    if [ -f index.sql ]; then \n\
    echo -- monitoring index.sql \n\
    nodemon -L -e sql --exec "sudo -u postgres psql -d dev -f index.sql" \n\
    fi \n\
    \n\
    \n\
    ' > /cmd/xrad \
    && chmod 755 /cmd/xrad
