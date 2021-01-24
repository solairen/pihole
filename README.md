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
In `inventory.yml`, set **IP**, **user**, **password** or **ssh_key** on where PiHole should be installed.</br>
If **ssh_key** is used, comment **password**.</br>
If **password** is used, comment **ssh_key**.</br>
```yml
linux:
    vars:
      ansible_ssh_user: user
      ansible_ssh_pass: password
      ansible_ssh_private_key_file: <path_to_key>
    children:
      pihole:
        hosts:
          127.0.0.1:
```

In `group_vars/all/common`, set **pihole version**, **time_zone** ,**docker_compose version**, **upload**, **destination**, **account_name**, **account_key**

```txt
_ph_version: latest               => PiHole version
_time_zone: Europe/Warsaw         => Set Time Zone
_docker_compose_version: 1.27.4   => Docker-compose version
_upload: 0                        => Upload to Azure Blob Storage. 1 - yes, 0 - no
_destination: {containerName}     => Set Azure Blob Storage container name
_account_name: {accountName}      => Set Azure Blob Storage account name
_account_key: {accountKey}        => Set Azure Blob Storage account key
```

### How to run:
```bash
ansible-playbook -i inventory.yml start.yml -e deployment=greenfield/brownfield -e 'ansible_python_interpreter=/usr/bin/python3' --ask-become-pass -vv
```
