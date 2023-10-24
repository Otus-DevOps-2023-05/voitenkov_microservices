FROM ruby:2.2.10-alpine
RUN apk update --no-cache \
    && apk add --no-cache build-base \
    && rm -rf /var/cache/apk/*
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN bundle install
ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
