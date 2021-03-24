### About:
This ansible script installs PiHole container on Ubuntu, Debian.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains own dns that will be disabled during the installation process.<br/>
The last step of installation process is set DNS to PiHole (host) IP address.

### Supported OS:
* Debian 9/10
* Ubuntu 18.04/20.04

### Prerequisites
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)
* [jmespath plugin](https://pypi.org/project/jmespath/)
* [Azure blob](https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az_storage_blob_upload)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [s3cmd](https://www.linode.com/docs/guides/how-to-use-object-storage/#s3cmd)

### Configuration

#### Azure Blob Storage
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) should be installed on host where PiHole is installed and Azure Blob Storage should be created on Azure.

#### Linode Object Storage
[s3cmd](https://www.linode.com/docs/guides/how-to-use-object-storage/#s3cmd) should be installed and configured on host where PiHole is installed and Object Storage should be created on Linode.

#### Firewall
On hosts where PiHole will be installed, **UFW** should be enabled and port `22` should be temporary added to rule.

#### Inventory.yml
In `inventory.yml`, set **IP**, **user**, **password**, **ssh port** or **ssh_key** on where PiHole should be installed.</br>
If **ssh_key** is used, comment **password**.</br>
If **password** is used, comment **ssh_key**.</br>
```yml
linux:
    vars:
      ansible_ssh_user: user
      ansible_ssh_pass: password
      ansible_port: 22
      ansible_ssh_private_key_file: <path_to_key>
    children:
      pihole:
        hosts:
          127.0.0.1:
```

#### Group_vars/all/common
In `group_vars/all/common`, set:

```txt
_ph_version: latest               => PiHole version
_time_zone: Europe/Warsaw         => Set Time Zone
_docker_compose_version: 1.27.4   => Docker-compose version
_public_ip: 127.0.0.1             => Set IP address that will be able to connect to host
_restore_from_backup:             => Restore PiHole from backup during greenfield installation.
  azure: 0                        => Restore from Azure. 1 - yes, 0 - no
  linode: 0                       => Restore from Linode. 1 - yes, 0 - no
_azure_upload: 0                  => Upload to Azure Blob Storage. 1 - yes, 0 - no
_container_name: {containerName}  => Set Azure Blob Storage container name
_account_name: {accountName}      => Set Azure Blob Storage account name
_account_key: {accountKey}        => Set Azure Blob Storage account key
_linode_upload: 0                 => Upload to Linode Ojbect Storage. 1 - yes, 0 - no
_linode_bucket: {bucketName}      => Linode Object Storage name
```

#### Restore from backup
To restore from backup, set 1 in variable `azure` or `linode` to choose from where backup should be downloaded.</br>
If `azure` is set, enter proper values to the `_container_name`, `_account_name` and `_account_key`.</br>
If `linode` is set, enter proper values to the `_linode_bucket` name.</br>
Setting 1 into both variables: `azure` and `linode` will fail the process of installation. 

### How to run:
```bash
ansible-playbook -i inventory.yml start.yml -e deployment=greenfield/brownfield -e 'ansible_python_interpreter=/usr/bin/python3' --ask-become-pass -vv
```