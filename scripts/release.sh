#!/bin/bash

set -euo pipefail

# Script to create versioned releases
# Usage: ./release.sh <version>
# Example: ./release.sh v1.2.3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Validate version format
validate_version() {
    local version="$1"
    if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_error "Invalid version format: $version"
        log_info "Expected format: v1.2.3"
        exit 1
    fi
}

# Check if working directory is clean
check_git_status() {
    if [ -n "$(git status --porcelain)" ]; then
        log_error "Working directory is not clean. Please commit or stash your changes."
        git status --short
        exit 1
    fi
}

# Validate proto files before release
validate_protos() {
    log_step "Validating protobuf definitions..."
    if ! "${SCRIPT_DIR}/validate.sh"; then
        log_error "Protobuf validation failed. Please fix errors before releasing."
        exit 1
    fi
}

# Generate code for all supported languages
generate_code() {
    log_step "Generating code for all supported languages..."
    "${SCRIPT_DIR}/generate.sh" all
}

# Create and push git tag
create_git_tag() {
    local version="$1"
    
    log_step "Creating git tag: $version"
    
    # Create annotated tag
    git tag -a "$version" -m "Release $version"
    
    log_info "Git tag $version created successfully"
    log_info "To push the tag, run: git push origin $version"
}

# Update version in files if needed
update_version_files() {
    local version="$1"
    # Remove 'v' prefix for version files
    local version_number="${version#v}"
    
    # You can add logic here to update version in specific files
    # For example, updating a VERSION file or package.json equivalent
    log_info "Version $version_number ready for release"
}

# Print release summary
print_summary() {
    local version="$1"
    
    echo ""
    log_info "═══════════════════════════════════════"
    log_info "Release $version created successfully!"
    log_info "═══════════════════════════════════════"
    echo ""
    log_step "Next steps:"
    echo "  1. Review the generated code in gen/ directory"
    echo "  2. Push the tag: git push origin $version"
    echo "  3. Create a GitHub release with release notes"
    echo "  4. Update consuming services to use new version"
    echo ""
}

# Main function
main() {
    if [ $# -ne 1 ]; then
        log_error "Usage: $0 <version>"
        log_info "Example: $0 v1.2.3"
        exit 1
    fi
    
    local version="$1"
    
    cd "$REPO_ROOT"
    
    validate_version "$version"
    check_git_status
    validate_protos
    generate_code
    update_version_files "$version"
    create_git_tag "$version"
    print_summary "$version"
}

# Run main function with all arguments
main "$@"