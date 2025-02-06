# Declare phony targets to ensure that 'make' always runs these recipes regardless of any files named 'all' or 'prod'
.PHONY: all server
all: ## Run dev
	iex -S mix  # The recipe to start the development server

help: ## Prints help for targets with comments
	grep -E '^[a-zA-Z._-]+:.*' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Run tests
	mix
