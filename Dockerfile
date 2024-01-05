# syntax=docker/dockerfile:1
FROM ruby:2.3

RUN echo "deb http://archive.debian.org/debian/ stretch main non-free contrib" > /etc/apt/sources.list

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    mysql-client \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]

