### About:
This ansible script installs PiHole in container on Ubuntu, Debian.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains own dns that will be disabled during the installation process.<br/>
The last step of installation process is set DNS to PiHole (host) IP address.

### Supported OS:
* Debian 9/10
* Ubuntu 18.04/20.04

### Prerequisites
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)
* [jmespath plugin](https://pypi.org/project/jmespath/)
* [Azure blob](https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az_storage_blob_upload)

### Configuration
In `inventory.yml`, set **user**, **password** and **IP** on where PiHole should be installed.

```yml
linux:
    vars:
      ansible_ssh_user: user
      ansible_ssh_pass: password
    children:
      pihole:
        hosts:
          127.0.0.1:
```

In `group_vars/all/common`, set **pihole version**, **time_zone** ,**docker_compose version**, **destination**, **account_name**, **account_key**

```txt
_ph_version: latest
_time_zone: Europe/Warsaw
_docker_compose_version: 1.27.4
_destination: {containerName}
_account_name: {accountName}
_account_key: {accountKey}
```

### How to run:
* ansible-playbook -i inventory.yml start.yml -e deployment=greenfield/brownfield -e 'ansible_python_interpreter=/usr/bin/python3' --ask-become-pass -vv