FROM alpine:3.3
RUN \
  apk --update add ruby ruby-json openssl ca-certificates && \
  rm -rf /var/cache/apk/*
RUN gem install --no-rdoc --no-ri aws-sdk json-schema parslet
ENV PATH /app/bin:$PATH
COPY . /app/
