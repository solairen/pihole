FROM moleszek/ansible:7.4.0

RUN apt-get update && apt-get -y install git openssh-server openssh-client dos2unix vim

WORKDIR /ansible

RUN mkdir /scripts
COPY scripts/ /scripts/

WORKDIR /ansible
COPY ansible/ .

RUN dos2unix /scripts/change_variable.sh

ENTRYPOINT [ "bash" ]
