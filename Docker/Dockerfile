FROM moleszek/ansible:latest

RUN apt update && apt -y install git openssh-server openssh-client dos2unix

WORKDIR /ansible

RUN mkdir /scripts
COPY scripts/ /scripts/

WORKDIR /ansible
COPY ansible/ .

RUN dos2unix /scripts/change_variable.sh

ENTRYPOINT [ "bash" ]
