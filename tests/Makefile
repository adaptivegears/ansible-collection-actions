### Make ######################################################################
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Ansible ###################################################################
.PHONY: up
up: ## Start the test VM
	cd vm && vagrant up

.PHONY: down
down: ## Stop the test VM
	cd vm && vagrant halt

.PHONY: status
status: ## Show VM status
	cd vm && vagrant status

.PHONY: ssh
ssh: ## SSH into the test VM
	cd vm && vagrant ssh

.PHONY: check
check: ## Test Ansible connectivity to VM
	ansible -i inventory debian12 -m ping


.PHONY: clean
clean: ## Clean up VM and artifacts
	cd vm && vagrant destroy -f
