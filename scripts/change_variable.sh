#!/bin/sh

function inventory() {
    # Remove old files
    rm -f /ansible/inventory.yml /scripts/templates/temp.ini

    # Set temp.yml
    ( echo "cat <<EOF >/ansible/inventory.ini";
      cat /scripts/templates/pihole-inventory-template.ini;
      echo;
      echo "EOF";
    ) >/scripts/templates/temp.ini

    # Run temp.yml
    . /scripts/templates/temp.ini
}

function common(){
    # Remove old files
    rm -f /ansible/group_vars/all/common /scripts/templates/common-tmp.yml

    # Set temp.yml
    ( echo "cat <<EOF >/ansible/group_vars/all/common.yml";
      cat /scripts/templates/pihole-common-template.yml;
      echo;
      echo "EOF";
    ) >/scripts/templates/common-tmp.yml

    # Run temp.yml
    . /scripts/templates/common-tmp.yml
}

inventory
common
