SHELL := /usr/bin/env bash -euo pipefail -c

main:
	@echo "invalid target" && false

test: clean setup teardown

clean:
	rm -rf ./.terraform

validate: clean
	terraform version
	rm -f .terraform.lock.hcl \
		&& terraform fmt --check \
		&& terraform init \
		&& terraform validate \

awscredcheck:
	@echo 'AWS_ACCESS_KEY_ID' && [ -v AWS_ACCESS_KEY_ID ]
	@echo 'AWS_SECRET_ACCESS_KEY' && [ -v AWS_SECRET_ACCESS_KEY ]
	@echo 'AWS_SESSION_TOKEN' && [ -v AWS_SESSION_TOKEN ]

setup: awscredcheck validate
	terraform apply -auto-approve
	# why 2 times?  this is to make sure the module doesn't have
	# any unexpected changes the second time around.
	terraform apply -auto-approve

teardown: awscredcheck
	terraform destroy -auto-approve

action:
	act -s TERRAFORM_MODULES_READONLY -C ../ \
		|| echo -e "\n:: NOTE: If act failed due to private repo issues, TERRAFORM_MODULES_READONLY needs to be set per README."

.PHONY: main test setup teardown validate clean action awscredcheck
