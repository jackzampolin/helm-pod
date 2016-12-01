FROM alpine

WORKDIR /root

COPY ./kubectl /usr/bin/kubectl
COPY ./helm /usr/bin/helm
RUN apk update && apk add wget tar ca-certificates

CMD ["/bin/sh"]