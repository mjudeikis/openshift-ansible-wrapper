ocp-ansible-wapper
=========

This repository provides unified view for all roles and playbooks to deploy and manage Openshift. It wrappes default Openshift Playbooks with custom entrypoints and allows to lifecycle them in your environment. 

Requirements
------------

ansible 2.2.0+

How it works?
------------

Project can be used with `bring-your-own` invetory or provissioned using terraform on aws.
Makefile helps to iniciate project and pull all dependencies.


Execution
------------
```
    make setup - setups terraform dependencies, ocp-terraform deployment project and ansible
    make terraform-plan-aws - shows plan for aws terraform provisioner
    make terraform-apply-aws - applies/provisions aws infrastructure using terraform

    make ansible-terraform-print - prints group data in json using dynamic invetory
    make ansible-terraform-test - tests ssh connection using dynamic invetory
```    

Terraform:
----------

You can use project `https://github.com/adammck/terraform-inventory` for invetory file too. This is included into design of the project/playbooks

Red Hat playbooks
------------

To get Red Hat ansible playbooks execute:
`git clone https://github.com/openshift/openshift-ansible.git -b release-3.7`

Author Information
------------------

Mangirdas Judeikis Mangirdas[et]Judeikis[dot]LT