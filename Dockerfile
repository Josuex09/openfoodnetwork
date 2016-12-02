#Dockerfile for openfoodnetwork development with ubuntu 14.04, and rvm as Ruby environments manager
#Build: 
#	docker build -t <image_name> .
#Run:
#	docker run -i -t <image_name>:latest /bin/bash --login

FROM ubuntu:14.04

#Install dependencies
RUN apt-get -y update && apt-get -y install \
	git-core curl zlib1g-dev build-essential libssl-dev \
	libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
	libxml2-dev libxslt1-dev libcurl4-openssl-dev \
	python-software-properties libffi-dev \
	gawk g++ gcc make libc6-dev patch	\
	git postgresql-9.3 postgresql-common libpq-dev phantomjs && apt-get clean

RUN apt-get -y install pgadmin3

## RVM Instalation

#Adding RVM Key
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

#Download
RUN curl -L https://get.rvm.io | bash -s stable

#Set ENV needed
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.5"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

USER postgres

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER ofn WITH SUPERUSER PASSWORD 'f00d';" &&\
    createdb -O ofn open_food_network_dev

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

USER root