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

.PHONY: test
test: $(ANSIBLE_ROLES)  ## Run lint checks on all roles

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

.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf *.tar.gz
