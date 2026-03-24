FROM ruby:3.2 AS builder
WORKDIR /app
COPY . .
RUN bundle install
RUN bundle exec jekyll build -d /app/_site

FROM nginx:stable-alpine
COPY --from=builder /app/_site /mnt/web/www/
