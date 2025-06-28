### Make ######################################################################
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Vagrant ###################################################################
.PHONY: up
up: ## Start VM
	vagrant up --parallel node1

.PHONY: cluster-up
cluster-up: ## Start VM cluster
	vagrant up --parallel node1 node2

.PHONY: destroy
destroy: ## Stop VM
	vagrant destroy -f --parallel

.PHONY: status
status: ## Show VM status
	vagrant status

.PHONY: check
check: ## Test Ansible connectivity to VM
	ansible node1 -m ping

.PHONY: clean
clean: destroy ## Clean up VM
	rm -rf .vagrant
