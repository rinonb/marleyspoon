FROM ruby:2.7.2

ARG APP_DIR=/app

RUN mkdir $APP_DIR

ADD . $APP_DIR

WORKDIR $APP_DIR

RUN bundle install

CMD ["bundle", "exec", "rackup"]
