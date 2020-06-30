### About:
This ansible script installs PiHole in container on Ubuntu OS.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains own dns that is disabled.<br/>
The last step of installation process is set DNS to PiHole (host) IP address.

### Prerequisites
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)
* [jmespath plugin](https://pypi.org/project/jmespath/)

### Configuration
In `inventory.yml`, set **user**, **password** and **IP** on where PiHole should be installed.

```yml
linux:
    vars:
      ansible_ssh_user: username
      ansible_ssh_pass: password
    children:
      pihole:
        hosts:
          127.0.0.1:
```

### How to run:
* ansible-playbook -i inventory start.yml --ask-become-pass