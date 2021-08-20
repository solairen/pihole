FROM moleszek/ansible:latest

WORKDIR /ansible

COPY ansible/ .

RUN addgroup -S ansible && adduser -S ansible -G ansible

RUN chown ansible:ansible /ansible

USER ansible

ENTRYPOINT [ "sh" ]
