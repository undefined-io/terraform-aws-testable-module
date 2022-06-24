SHELL := /usr/bin/env bash -euo pipefail -c

#https://www.gnu.org/software/make/manual/make.html
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

AWS_RETRY_MODE=standard
AWS_MAX_ATTEMPTS=1

main:
	@echo "action      : Simulate github action locally"
	@echo "awscredcheck: Check if AWS access is valid"
	@echo "clean       : Cleanup any temp files"
	@echo "setup       : Runs two applies of the terraform in AWS"
	@echo "teardown    : Destroy the apply in AWS"
	@echo "integration : Run setup and teardown"
	@echo "validate    : Purely local full syntax validation"
	@false

integration: clean validate
	@(terraform apply -auto-approve \
			&& terraform apply -auto-approve) \
			|| true
	terraform destroy -auto-approve

clean:
	rm -f .terraform.lock.hcl
	rm -rf ./.terraform

validate: clean
	@terraform version
	@terraform fmt --check \
		&& terraform init \
		&& terraform validate -json \
		| jq --unbuffered -rc \
		'.diagnostics[] | {severity: .severity, detail: .detail, filename: .range.filename, start_line: .range.start.line}'

awscredcheck:
	aws sts get-caller-identity

setup: awscredcheck validate
	@terraform apply -auto-approve -json \
		| jq --unbuffered -rc .
	# why 2 times?  this is to make sure the module doesn't have
	# any unexpected changes the second time around.
	@terraform apply -auto-approve -json \
		| jq --unbuffered -rc .

teardown: awscredcheck
	@terraform destroy -auto-approve -json \
		| jq --unbuffered -rc .

action:
	@act -s TERRAFORM_MODULES_READONLY -C ../ \
		|| echo -e "\n:: NOTE: If act failed due to private repo issues, TERRAFORM_MODULES_READONLY needs to be set per README."

.PHONY: main integration setup teardown validate clean action awscredcheck
