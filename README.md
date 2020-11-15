### About:
This ansible script installs PiHole in container on Ubuntu and Debian OS.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains own dns that will be disabled during the installation process.<br/>
The last step of installation process is set DNS to PiHole (host) IP address.

### Supported OS:
* Debian 9/10
* Ubuntu 18.04/20.04

### Prerequisites
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)
* [jmespath plugin](https://pypi.org/project/jmespath/)

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

In `group_vars/all/common`, set **pihole version**, **time_zone** and **docker_compose version**

```txt
_ph_version: latest
_time_zone: Europe/Warsaw
_docker_compose_version: 1.26.0
```

### How to run:
* ansible-playbook -i inventory start.yml -e deployment=greenfield/brownfield -e 'ansible_python_interpreter=/usr/bin/python3' --ask-become-pass -vv