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
	@echo "plan      : Plan after unit-test"
	@echo "apply     : Apply after unit-test"
	@echo "destroy   : Destroy all resources"
	@echo "full-test : Applies and destroys all resources"
	@echo "unit-test : Purely local full syntax validation"
	@echo "docs      : Creates/Updates the module documentation"
	@true

clean:
	rm -f .terraform.lock.hcl
	rm -rf ./.terraform

#
# - At GLG we don't use HTTP web proxies for normal web requests.
# - "iamlive" has a proxy mode uses web proxies with the AWS SDK
# The reason why HTTP(S)_PROXY for init is set to '' is so that iamlive
#   can have a proxy running and potentially in env vars, and
#   terraform init can download providers skipping the HTTP proxy.
#
# Quick explanation
# - we print the version so it's clear which one is being used
# - reformat all terraform files (key thing people are not doing)
# - turn off the proxies for init so providers download
# - validate & plan
#

plan: clean
	@terraform version \
		&& terraform fmt --recursive \
		&& cd "examples/simple-usage" \
		&& HTTP_PROXY='' HTTPS_PROXY='' terraform init \
		&& terraform validate \
		&& terraform plan

unit-test: clean
	@terraform version \
		&& terraform fmt --recursive \
		&& cd "examples/simple-usage" \
		&& HTTP_PROXY='' HTTPS_PROXY='' terraform init \
		&& terraform validate

full-test: clean unit-test
	# why 2 times?  this is to make sure the module doesn't have
	# any unexpected changes the second time around.
	@cd "examples/simple-usage" \
		&& (terraform apply -auto-approve \
			&& terraform apply -auto-approve) \
		|| true \
		;	terraform destroy -auto-approve

aws-creds:
	aws --no-cli-pager sts get-caller-identity

apply: aws-creds unit-test
	@cd "examples/simple-usage" \
		&& terraform apply -auto-approve

destroy: aws-creds
	@cd "examples/simple-usage" \
		&& terraform destroy -auto-approve

action:
	@act -s TF_TESTABLE_MODULE_SSH_KEY -C . \
		|| echo -e "\n:: NOTE: If act failed due to private repo issues, TF_TESTABLE_MODULE_SSH_KEY needs to be set per README."

docs:
	# we need to make sure  a file exists, or docker will create it as root:root
	touch README.md
	# now "update" the existing README.md
	docker run \
		--rm \
		-u $(id -u):$(id -g) \
		--volume "$(CURDIR):/terraform-docs" \
		quay.io/terraform-docs/terraform-docs:0.17.0 \
		markdown terraform-docs \
		--config /terraform-docs/.config/terraform-docs.yml

.PHONY: main full-test apply destroy unit-test clean aws-creds plan action docs
