#!/bin/sh

function inventory() {
    # Remove old files
    rm -f /ansible/inventory.yml /scripts/templates/temp.yml

    # Set temp.yml
    ( echo "cat <<EOF >/ansible/inventory.yml";
      cat /scripts/templates/pihole-inventory-template.yml;
      echo;
      echo "EOF";
    ) >/scripts/templates/temp.yml

    # Run temp.yml
    . /scripts/templates/temp.yml
}

function common(){
    # Remove old files
    rm -f /ansible/group_vars/all/common /scripts/templates/common-tmp

    # Set temp.yml
    ( echo "cat <<EOF >/ansible/group_vars/all/common";
      cat /scripts/templates/pihole-common-template;
      echo;
      echo "EOF";
    ) >/scripts/templates/common-tmp

    # Run temp.yml
    . /scripts/templates/common-tmp 
}

inventory
common