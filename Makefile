###
### Variables
###

ANSIBLE_FORCE_COLOR = 1

# https://serverfault.com/questions/1031491/display-ansible-playbook-output-properly-formatted
# https://stackoverflow.com/questions/50009505/ansible-stdout-formatting
ANSIBLE_STDOUT_CALLBACK = unixy


### Playbook name
playbook ?= main.yml
inventory ?= inventory.yml
reqs ?= requirements.yml

### Lint yaml files
lint:
	cd tests && ansible-lint test.yml -c ../.ansible-lint
	cd tests && ansible-playbook test.yml --syntax-check
.PHONY: lint

### Run tests
test:
	cd tests && ansible-playbook test.yml
.PHONY: test

test-install:
	cd tests && ansible-playbook test.yml --tags dock-install
.PHONY: test

test-add:
	cd tests && ansible-playbook test.yml --tags dock-add
.PHONY: test

test-remove:
	cd tests && ansible-playbook test.yml --tags dock-remove
.PHONY: test

test-position:
	cd tests && ansible-playbook test.yml --tags dock-position
.PHONY: test

### List all hostnames
ls-host:
	ansible all -i $(inventory) -m shell -a "hostname;"
.PHONY: ls-host

### Check playbook syntax
check-syntax:
	ansible-playbook $(playbook) -i $(inventory) --syntax-check
.PHONY: check-syntax

### Install ansible dependencies
install-deps:
	ansible-galaxy install -r $(reqs)
.PHONY: install-deps

### Git
hooks:
	pre-commit install
.PHONY: install-hooks
