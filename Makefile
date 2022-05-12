###
### Variables
###

ANSIBLE_FORCE_COLOR = 1

# https://serverfault.com/questions/1031491/display-ansible-playbook-output-properly-formatted
# https://stackoverflow.com/questions/50009505/ansible-stdout-formatting
ANSIBLE_STDOUT_CALLBACK = unixy


### Playbook name
playbook ?= test.yml
workdir ?= ./tests
inventory ?= inventory.yml
reqs ?= requirements.yml

### Lint yaml files
lint:
	cd $(workdir) && ansible-lint $(playbook) -c ../.ansible-lint
	cd $(workdir) && ansible-playbook $(playbook) --syntax-check
.PHONY: lint

### Run tests
test:
	cd $(workdir) && ansible-playbook $(playbook)
.PHONY: test

test-validate:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-validate
.PHONY: test

test-install:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-install
.PHONY: test

test-manipulate:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-manipulate
.PHONY: test

test-add:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-add
.PHONY: test

test-remove:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-remove
.PHONY: test

test-move:
	cd $(workdir) && ansible-playbook $(playbook) --tags dock-move
.PHONY: test

### List all hostnames
ls-host:
	cd $(workdir) && ansible all -i $(inventory) -m shell -a "hostname;"
.PHONY: ls-host

### Check playbook syntax
check-syntax:
	cd $(workdir) && ansible-playbook $(playbook) -i $(inventory) --syntax-check
.PHONY: check-syntax

### Install ansible dependencies
install-deps:
	ansible-galaxy install -r $(reqs)
.PHONY: install-deps

### Git
hooks:
	pre-commit install
.PHONY: install-hooks
