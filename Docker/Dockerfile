FROM moleszek/ansible:latest

RUN apk add --no-cache git openssh

RUN mkdir /scripts
COPY scripts/ /scripts/

WORKDIR /ansible
COPY ansible/ .

RUN addgroup -S ansible && adduser -S ansible -G ansible
RUN chown -R ansible:ansible /ansible
RUN chown -R ansible:ansible /scripts

USER ansible

ENTRYPOINT [ "sh" ]
