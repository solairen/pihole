### About:
This ansible script installs PiHole container or PiHole standalone on Ubuntu or Raspberry Pi in version 4 or 5.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains its DNS that will be disabled during the installation process.<br/>
The last step of the installation process is to set DNS to PiHole (host) IP address.

### Supported OS:
* Ubuntu 20.04
* Ubuntu 22.04
* Raspberry Pi 4/5

### Prerequisites
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)
* [jmespath plugin](https://pypi.org/project/jmespath/)
* [Azure blob](https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az_storage_blob_upload)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [s3cmd](https://www.linode.com/docs/guides/how-to-use-object-storage/#s3cmd)
* [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

### Configuration

#### Azure Blob Storage
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) should be installed on the host where PiHole is installed and Azure Blob Storage should be created on Azure.

It is a possibility to upload backup to all cloud providers at one time, to do that those programs: **azure CLI**, **s3cmd**, **boto3** must be installed on the host where PiHole is installed.

> **_NOTE:_** S3CMD and boto3 are installed during installation process.

#### Firewall
On host where PiHole will be installed, **UFW** should be enabled and a port that has been configured to ssh connection should be temporary added to the rule.

#### Inventory.ini
In `inventory.ini`, set **IP**, **user**, **password**, **ssh port** or **ssh_key** on where PiHole should be installed.</br>
If **ssh_key** is used, comment **password**.</br>
If **password** is used, comment **ssh_key**.</br>
```ini
[pihole]
127.0.0.1

[pihole:vars]
ansible_ssh_user=user
ansible_ssh_pass=password
ansible_ssh_private_key_file=<path_to_key>
ansible_port=22
```

#### Group_vars/all/common.yml
In `group_vars/all/common.yml`, set:

```txt
_ph_version: latest               => PiHole version. Used only when PiHole is installed using Docker.
_ph_restore_version:              => Set PiHole version to restore if installation failed during brownfield. Used only when PiHole is installed using Docker.
_pihole_webpassword:              => Set PiHole Web password. Used only when PiHole is installed as standalone.
_dns_server_1: 1.1.1.1            => Set PiHole DNS server. Used only when PiHole is installed as standalone.
_dns_server_2: 1.0.0.1            => Set PiHole DNS server. Used only when PiHole is installed as standalone.
_time_zone: Europe/Warsaw         => Set Time Zone.
_docker_compose_version: 1.27.4   => Docker-compose version.
_restore_from_backup:             => Restore PiHole from backup during greenfield installation.
  azure: 0                        => Restore from Azure. 1 - yes, 0 - no.
  linode: 0                       => Restore from Linode. 1 - yes, 0 - no.
  aws: 0                          => Restore from AWS S3. 1 - yes, 0 - no.
_azure_upload: 0                  => Upload to Azure Blob Storage. 1 - yes, 0 - no.
_container_name: {containerName}  => Set Azure Blob Storage container name.
_account_name: {accountName}      => Set Azure Blob Storage account name.
_account_key: {accountKey}        => Set Azure Blob Storage account key.
_linode_upload: 0                 => Upload to Linode Ojbect Storage. 1 - yes, 0 - no.
_linode_bucket: {bucketName}      => Linode Object Storage name.
_linode_access_key: {accessKey}   => Linode Object Storage access key.
_linode_secret_key: {secretKey}   => Linode Object Storage secret key.
_host: {regionName}               => Linode Object Storage region.
_aws_upload: 0                    => Upload to AWS S3. 1 - yes, 0 - no.
_aws_bucket: {bucketName}         => AWS S3 Bucket name.
_aws_access_key: {accessKey}      => AWS access key.
_aws_secret_key: {secretKey}      => AWS secret key.
```

#### Restore from backup
To restore from backup, set 1 in variable `azure`, `linode` or `aws` to choose from where the backup should be downloaded.</br>
If `azure` is set, enter proper values to the `_container_name`, `_account_name` and `_account_key`.</br>
If `linode` is set, enter proper values to the `_linode_bucket`.</br>
If `aws` is set, enter proper values to the `_aws_bucket`, `_aws_access_key` and `_aws_secret_key`.</br>
Setting 1 into variables: `azure`, `linode` and `aws` at the same time will fail the process of installation.

### How to run:

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventory.ini install_pihole.yml -e deployment=greenfield/brownfield -e installation_type=standalone/docker --ask-become-pass -vv
```

### Additional information
Inside folder ``/scripts`` there is a script file ``change_variable.sh`` that will replace ``common.yml`` and ``inventory.ini`` files with proper values based on environment variables.

#### How to run

Set environment variables on host from where the ansible script will be run or inside the docker container ([moleszek/pihole:latest](https://hub.docker.com/r/moleszek/pihole)) e.g:

```bash
export USER=testuser
export PASSWORD=testpassword
export AWSUPLOAD=1
export AWSBUCKET=testbucket
export AWSACCESSKEY=1234
export AWSSECRETKEY=56789
```

Run script:

```bash
sh scripts/change_variable.sh
```

Old ``common.yml`` and ``inventory.ini`` file will be replace with new one and with values that has been taken from environment variable.
