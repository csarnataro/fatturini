# Fatturini

This is my personal invoicing system, built on Ruby on Rails 4.0.0 a few years ago.
It served me well for years (when I was a freelancer) but it's not maintained anymore.

It's tailored on my specific needs, so it can not be used "as is", but it shouldn't be that hard to adapt it to be more "general purpose".

It was originally hosted on Openshift in the free tier, that's why there are many references to Openshift environment variable, (like `<%=ENV['OPENSHIFT_APP_NAME']%>`).

I'm storing it here on GitHub for future reference (or in case a become a freelancer again).

## How to run the app locally using Docker

Inspired by https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/rails/

- docker compose build
- docker compose up
- head to http://localhost:3000