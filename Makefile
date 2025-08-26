.PHONY: help validate generate clean release

# Default target
help:
	@echo "Todo App Protocol Buffers"
	@echo ""
	@echo "Available targets:"
	@echo "  validate    - Validate protobuf definitions"
	@echo "  generate    - Generate code for all languages"
	@echo "  generate-go - Generate Go code only"
	@echo "  clean       - Clean generated files"
	@echo "  release     - Create a new release (usage: make release VERSION=v1.2.3)"
	@echo "  help        - Show this help message"

# Validate protobuf definitions
validate:
	@./scripts/validate.sh

# Generate code for all languages
generate:
	@./scripts/generate.sh all

# Generate Go code only
generate-go:
	@./scripts/generate.sh go

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -rf gen/
	@echo "Clean completed."

# Create a release (requires VERSION variable)
release:
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION is required. Usage: make release VERSION=v1.2.3"; \
		exit 1; \
	fi
	@./scripts/release.sh $(VERSION)