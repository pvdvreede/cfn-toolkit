FROM alpine:3.3
ARG BUNDLE_WITHOUT=production
RUN \
  apk --update add ruby ruby-json ruby-bundler ruby-io-console openssl ca-certificates && \
  rm -rf /var/cache/apk/*
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN cd /app && bundle install --jobs=4 --without=$BUNDLE_WITHOUT
ENV PATH /app/bin:$PATH
COPY . /app/
