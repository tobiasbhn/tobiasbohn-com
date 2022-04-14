# Base
FROM ruby:3.0.0-alpine AS base
LABEL maintainer="Tobias Bohn <info@tobiasbohn.com>"

ARG APP_PATH=/application/
ENV APP_PATH=$APP_PATH

WORKDIR $APP_PATH


# Builder
FROM base AS builder

RUN bundle config --global frozen 1 \
  && apk --no-cache --update add \
  build-base \
  ruby-dev \
  postgresql-dev \
  tzdata \
  bash \
  git \
  # for tailwindcss (https://github.com/rails/tailwindcss-rails/issues/115):
  gcompat \
  && gem install bundler:2.2.3

COPY Gemfile* $APP_PATH


# Developer Bundle
FROM builder AS dev_bundle

RUN bundle install -j4 --retry 3 \
  && bundle clean --force \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_PATH


# Production Bundle
FROM builder AS prod_bundle

RUN bundle install --without development test -j4 --retry 3 \
  && bundle clean --force \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_PATH

ARG RAILS_MASTER_KEY
RUN RAILS_ENV=production bundle exec rake assets:precompile \
  && rm -rf tmp/cache app/assets/builds app/assets/images app/assets/stylesheets vendor/assets lib/assets spec


# Developer Final
FROM base AS development

EXPOSE 3000
COPY entrypoints/web-entrypoint.sh /usr/bin/entrypoint.sh
COPY entrypoints/job-entrypoint.sh /usr/bin/job-entrypoint.sh

RUN apk --update --no-cache add \
  postgresql-client \
  chromium-chromedriver \
  chromium \
  tzdata \
  bash \
  vips \
  # for tailwindcss (https://github.com/rails/tailwindcss-rails/issues/115):
  gcompat \
  && chmod +x /usr/bin/entrypoint.sh \
  && chmod +x /usr/bin/job-entrypoint.sh

COPY --from=dev_bundle /usr/local/bundle/ /usr/local/bundle/
COPY --from=dev_bundle $APP_PATH $APP_PATH

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]


# Production Final
FROM base AS production

ENV RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  EXECJS_RUNTIME=Disabled

EXPOSE 3000
COPY entrypoints/web-entrypoint.sh /usr/bin/entrypoint.sh
COPY entrypoints/job-entrypoint.sh /usr/bin/job-entrypoint.sh

RUN apk --update --no-cache add \
  postgresql-client \
  tzdata \
  bash \
  vips \
  && chmod +x /usr/bin/entrypoint.sh \
  && chmod +x /usr/bin/job-entrypoint.sh

COPY --from=prod_bundle /usr/local/bundle/ /usr/local/bundle/
COPY --from=prod_bundle $APP_PATH $APP_PATH

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
