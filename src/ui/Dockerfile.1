FROM ruby:2.2.10-alpine
RUN apk update --no-cache \
    && apk add --no-cache build-base \
    && rm -rf /var/cache/apk/*
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN bundle install \
    && apk del build-base
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
CMD ["puma"]
