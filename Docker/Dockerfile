FROM moleszek/ansible:latest

RUN apk add --no-cache git openssh dos2unix

WORKDIR /ansible

RUN mkdir /scripts
COPY scripts/ /scripts/

WORKDIR /ansible
COPY ansible/ .

RUN dos2unix /scripts/change_variable.sh

ENTRYPOINT [ "sh" ]
