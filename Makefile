MAKEFLAGS += --silent
TERRAFORM_ANSIBLE=https://github.com/adammck/terraform-inventory/releases/download/v0.7-pre/terraform-inventory_v0.7-pre_linux_amd64.zip
TF_STATE=./terraform/openshift-terraform-ansible/ec2/terraform.tfstate

setup: setup-terraform setup-ocp-terraform setup-ansible

setup-terraform:
	wget ${TERRAFORM_ANSIBLE} -O /tmp/terraform.zip && \
	unzip -o /tmp/terraform.zip -d ./terraform/ 

setup-ocp-terraform:
	rm -rf ./terraform/openshift-terraform-ansible && \
	git clone https://github.com/mjudeikis/openshift-terraform-ansible.git ./terraform/openshift-terraform-ansible && \
	if [ -a ~/aws/credentials.tfvars ] ; \
	then \
    	cp ~/aws/credentials.tfvars ./terraform/openshift-terraform-ansible/ec2/ ; \
	fi;

setup-ansible:
	ansible-galaxy install -r roles/requirements.yml -c && \
	rm -rf ./openshift-ansible && \
	git clone https://github.com/openshift/openshift-ansible.git -b release-3.7

terraform-plan-aws:
	cd terraform/openshift-terraform-ansible/ec2 && \
	make plan

terraform-apply-aws:
	cd terraform/openshift-terraform-ansible/ec2 && \
	make apply

ansible-terraform-print:
	./terraform/terraform-inventory --list ${TF_STATE} | python -m json.tool

ansible-terraform-test:
	echo "Masters" && \
	TF_STATE=${TF_STATE} ansible role_masters -i ./terraform/terraform-inventory -a hostname && \
	echo "Nodes" && \
	TF_STATE=${TF_STATE} ansible role_nodes -i ./terraform/terraform-inventory -a hostname && \
	echo "GlusterFS" && \
	TF_STATE=${TF_STATE} ansible role_glusterfs -i ./terraform/terraform-inventory -a hostname
	

ansible-terraform-install:
	TF_STATE=${TF_STATE} ansible-playbook --inventory-file=./terraform/terraform-inventory playbooks/ocp-install.yml

ansible-terraform-pre:
	TF_STATE=${TF_STATE} ansible-playbook --inventory-file=./terraform/terraform-inventory playbooks/ocp-pre.yml

ansible-terraform-post:
	TF_STATE=${TF_STATE} ansible-playbook --inventory-file=./terraform/terraform-inventory playbooks/ocp-post.yml
