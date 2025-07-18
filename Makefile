### Make ######################################################################
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Ansible ###################################################################
ANSIBLE_ROLES := $(shell find roles -mindepth 1 -maxdepth 1 -type d)

.PHONY: $(ANSIBLE_ROLES)
$(ANSIBLE_ROLES):
	ansible-lint $@

.PHONY: format
format: ## Automatically format the source code
	@ansible-lint -v

.PHONY: lint
lint: $(ANSIBLE_ROLES)  ## Run lint checks on all roles

.PHONY: build
build: format ## Build collection archive
	ansible-galaxy collection build --force

.PHONY: install
install: build ## Install collection
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy collection install *.tar.gz

.PHONY: release
release: clean build ## Publish collection
	ansible-galaxy collection publish *.tar.gz --api-key $(GALAXY_API_KEY)

### Testing ###################################################################
VAGRANT := $(MAKE) -C tests/vm

.PHONY: vm-up
vm-up: ## Start test VM
	$(VAGRANT) up

.PHONY: vm-cluster-up
vm-cluster-up: ## Start multi-node test VMs
	$(VAGRANT) cluster-up

.PHONY: vm-destroy
vm-destroy: ## Stop test VM
	$(VAGRANT) destroy

.PHONY: vm-reset
vm-reset: ## Reset test VM
	$(VAGRANT) destroy
	$(VAGRANT) up
	$(VAGRANT) check

.PHONY: vm-cluster-reset
vm-cluster-reset: ## Reset multi-node test VMs
	$(VAGRANT) destroy
	$(VAGRANT) cluster-up
	$(VAGRANT) check

.PHONY: test-ansible-role-apt
test-ansible-role-apt: ## Run playbook against VM
	ansible-playbook tests/playbooks/ansible-role-apt.yml

.PHONY: test-ansible-role-debian
test-ansible-role-debian: ## Run debian role test with purge functionality
	ansible-playbook tests/playbooks/ansible-role-debian.yml

.PHONY: test-ansible-role-ssh
test-ansible-role-ssh: ## Run SSH role test with comprehensive security validation
	ansible-playbook tests/playbooks/ansible-role-ssh.yml

.PHONY: test-ansible-role-nodejs
test-ansible-role-nodejs: ## Run Node.js role test with installation and configuration validation
	ansible-playbook tests/playbooks/ansible-role-nodejs.yml

.PHONY: test-tailscale
test-tailscale: ## Run Tailscale role test with CLI and service validation
	ansible-playbook tests/playbooks/debian12-tailscale.yml


.PHONY: test-ansible-role-kubernetes
test-ansible-role-kubernetes: ## Run multi-node kubernetes cluster test
	ansible-playbook tests/playbooks/ansible-role-kubernetes.yml


.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf *.tar.gz
