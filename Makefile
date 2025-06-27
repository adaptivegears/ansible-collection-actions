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
.PHONY: vm-up vm-down vm-reset test-run
vm-up: ## Start test VM
	$(MAKE) -C tests up

vm-down: ## Stop test VM
	$(MAKE) -C tests down

vm-reset: ## Recreate VM and test connectivity
	$(MAKE) -C tests clean && $(MAKE) -C tests up && $(MAKE) -C tests check

vm-cluster-up: ## Start multi-node cluster VMs
	cd tests/vm && vagrant up debian12 debian12-worker

vm-cluster-down: ## Stop multi-node cluster VMs  
	cd tests/vm && vagrant halt debian12 debian12-worker

vm-cluster-reset: vm-cluster-down vm-cluster-up ## Complete multi-node cluster reset
	ansible cluster -m ping

test: ## Run playbook against VM
	ansible-playbook tests/playbooks/debian12-apt.yml

test-debian: ## Run debian role test with purge functionality
	ansible-playbook tests/playbooks/debian12-debian.yml

test-ssh: ## Run SSH role test with comprehensive security validation
	ansible-playbook tests/playbooks/debian12-ssh.yml

test-tailscale: ## Run Tailscale role test with CLI and service validation
	ansible-playbook tests/playbooks/debian12-tailscale.yml

test-kubernetes: ## Run Kubernetes role test with cluster initialization and validation
	ansible-playbook tests/playbooks/debian12-kubernetes.yml

test-kubernetes-multinode: ## Run multi-node kubernetes cluster test
	ansible-playbook tests/playbooks/debian12-kubernetes-multinode.yml

test-kubernetes-join: ## Run kubernetes join logic validation test
	ansible-playbook tests/playbooks/debian12-kubernetes-join.yml

.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf *.tar.gz
