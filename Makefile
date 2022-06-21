###
### Variables
###

export ANSIBLE_FORCE_COLOR = 1
export ANSIBLE_JINJA2_NATIVE = true

export PY_COLORS = 1
export PYTHONIOENCODING = UTF-8
export LC_CTYPE = en_US.UTF-8
export LANG = en_US.UTF-8

# https://serverfault.com/questions/1031491/display-ansible-playbook-output-properly-formatted
# https://stackoverflow.com/questions/50009505/ansible-stdout-formatting
export ANSIBLE_STDOUT_CALLBACK = unixy

TASK_TAGS ?= "dock-validate dock-install dock-manipulate dock-add dock-remove dock-move"
PLAYBOOK ?= test.yml
WORKDIR ?= ./tests
INVENTORY ?= inventory.yml
REQS ?= requirements.yml
INSTALL_POETRY ?= true
POETRY ?= poetry run

# leave empty to disable
# -v - verbose;
# -vvv - more details
# -vvv - enable connection debugging
DEBUG_VERBOSITY ?= -vvv

TEST_PLAYBOOK = $(POETRY) ansible-playbook $(PLAYBOOK) -i $(INVENTORY) $(DEBUG_VERBOSITY)
TEST_IDEMPOTENT = $(TEST_PLAYBOOK) | tee /dev/tty | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)

### Lint yaml files
lint: check-syntax
	$(POETRY) yamllint .
	cd $(WORKDIR) && $(POETRY) ansible-lint $(PLAYBOOK) -c ../.ansible-lint
.PHONY: lint

### Run tests
test:
	cd $(WORKDIR) && $(TEST_PLAYBOOK)
.PHONY: test

test-idempotent:
	cd $(WORKDIR) && $(TEST_IDEMPOTENT)
.PHONY: test-idempotent

test-validate: TASK_TAGS="dock-validate"
test-validate: test-tag

test-install: TASK_TAGS="dock-install"
test-install: test-tag

test-manipulate: TASK_TAGS="dock-manipulate"
test-manipulate: test-tag

test-add: TASK_TAGS="dock-add"
test-add: test-tag

test-remove: TASK_TAGS="dock-remove"
test-remove: test-tag

test-move: TASK_TAGS="dock-move"
test-move: test-tag

test-tag:
	cd $(WORKDIR) && $(TEST_PLAYBOOK) --tags $(TASK_TAGS)
.PHONY: test-tag

#m-test:
#	poetry run molecule test -- $(DEBUG_VERBOSITY)
#.PHONY: m-test

m-local:
	poetry run molecule test --scenario-name defaults-restored-on-localhost -- -vvv --tags $(TASK_TAGS)
.PHONY: m-local

m-remote:
	poetry run molecule test --scenario-name defaults-restored-over-ssh -- -vvv --tags $(TASK_TAGS)
.PHONY: m-remote

debug-version:
	ansible --version
.PHONY: debug-version

check:
	cd $(WORKDIR) && $(TEST_PLAYBOOK) --check
.PHONY: check

### List all hostnames
ls-host:
	cd $(WORKDIR) && $(POETRY) ansible all -i $(INVENTORY) -m shell -a "hostname;"
.PHONY: ls-host

### Check playbook syntax
check-syntax:
	cd $(WORKDIR) && $(TEST_PLAYBOOK) --syntax-check
.PHONY: check-syntax

### Install ansible dependencies
install: install-poetry install-deps
.PHONY: install

install-deps:
	poetry install
	$(POETRY) ansible-galaxy install -r $(REQS)
.PHONY: install-deps

install-poetry:
ifeq ($(INSTALL_POETRY),true)
	sudo sh contrib/poetry-bin/install.sh
else
	@echo "Poetry installation disabled by global variable! Exiting..."
	@exit 0
endif
.PHONY: install-poetry

### Git
hooks:
	pre-commit install
.PHONY: install-hooks
