FROM moleszek/ansible:latest

RUN apk add --no-cache git openssh

WORKDIR /ansible

COPY ansible/ .

RUN addgroup -S ansible && adduser -S ansible -G ansible

RUN chown -R ansible:ansible /ansible

USER ansible

ENTRYPOINT [ "sh" ]
