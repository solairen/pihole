<p align="left">
    <a href="https://hub.docker.com/r/moleszek/pihole">
        <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/moleszek/pihole/latest">
    </a>
    <a href="https://hub.docker.com/r/moleszek/pihole">
        <img alt="Docker Image Size (tag)" src="https://img.shields.io/docker/image-size/moleszek/pihole/latest">
    </a>
    <a href="https://hub.docker.com/r/moleszek/pihole">
        <img alt="Docker Automated build" src="https://img.shields.io/docker/automated/moleszek/pihole">
    </a>
</p>

### About:
This ansible script installs PiHole container on Ubuntu.<br/>
According to [PiHole](https://github.com/pi-hole/docker-pi-hole) documentation, Ubuntu contains its DNS that will be disabled during the installation process.<br/>
The last step of the installation process is to set DNS to PiHole (host) IP address.

### Supported OS:
* Ubuntu 20.04

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

#### Inventory.yml
In `inventory.yml`, set **IP**, **user**, **password**, **ssh port** or **ssh_key** on where PiHole should be installed.</br>
If **ssh_key** is used, comment **password**.</br>
If **password** is used, comment **ssh_key**.</br>
```yml
linux:
    vars:
      ansible_ssh_user: username
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
_ph_version: latest               => PiHole version.
_ph_restore_version:              => Set PiHole version to restore if installation failed during brownfield.
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
ansible-playbook -i inventory.yml install_pihole.yml -e deployment=greenfield/brownfield --ask-become-pass -vv
```

### Additional information
Inside folder ``/scripts`` there is a script file ``change_variable.sh`` that will replace ``common`` and ``inventory.yml`` files with proper values based on environment variables.

#### How to run

Set environment variables on host from where the ansible scirpt will be run or inside the docker container ([moleszek/pihole:latest](https://hub.docker.com/r/moleszek/pihole)) e.g:

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

Old ``common`` and ``inventory.yml`` file will be replace with new one and with values that has been taken from environment variable.
