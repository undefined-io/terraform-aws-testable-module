SHELL := /usr/bin/env bash -euo pipefail -c

#https://www.gnu.org/software/make/manual/make.html
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

AWS_RETRY_MODE=standard
AWS_MAX_ATTEMPTS=1
TF_IN_AUTOMATION=1

main:
	@echo "action    : Simulate github action locally"
	@echo "aws-creds : Check if AWS access is valid"
	@echo "clean     : Cleanup any temp files"
	@echo "setup     : Runs two applies of the terraform in AWS"
	@echo "teardown  : Destroy the apply in AWS"
	@echo "full-test : Run setup and teardown"
	@echo "unit-test : Purely local full syntax validation"
	@false

clean:
	rm -f .terraform.lock.hcl
	rm -rf ./.terraform

unit-test: clean
	@terraform version
	@cd "examples/simple-usage"
	@terraform fmt --check \
		&& terraform init \
		&& terraform validate
		@#&& terraform validate -json \
		#| jq --unbuffered -rc \
		#'.diagnostics[] | {severity: .severity, detail: .detail, filename: .range.filename, start_line: .range.start.line}'

full-test: clean unit-test
	# why 2 times?  this is to make sure the module doesn't have
	# any unexpected changes the second time around.
	@cd "examples/simple-usage"
	@(terraform apply -auto-approve \
			&& terraform apply -auto-approve) \
			|| true
	terraform destroy -auto-approve

aws-creds:
	aws sts get-caller-identity

setup: aws-creds unit-test
	@cd "examples/simple-usage"
	@terraform apply -auto-approve
	@#terraform apply -auto-approve -json | jq --unbuffered -rc .

teardown: aws-creds
	@cd "examples/simple-usage"
	@terraform destroy -auto-approve
	@#terraform destroy -auto-approve -json | jq --unbuffered -rc .

action:
	@act -s TF_TESTABLE_MODULE_SSH_KEY -C . \
		|| echo -e "\n:: NOTE: If act failed due to private repo issues, TF_TESTABLE_MODULE_SSH_KEY needs to be set per README."

.PHONY: main full-test setup teardown unit-test clean action aws-creds
