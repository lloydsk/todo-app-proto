#!/bin/bash

set -euo pipefail

# Script to validate protobuf definitions
# Usage: ./validate.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROTO_DIR="${REPO_ROOT}/proto"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if protoc is installed
check_protoc() {
    if ! command -v protoc &> /dev/null; then
        log_error "protoc is not installed. Please install Protocol Buffer compiler."
        exit 1
    fi
}

# Validate proto files
validate_protos() {
    log_info "Validating protobuf definitions..."
    
    # Find all .proto files
    local proto_files=$(find "${PROTO_DIR}" -name "*.proto")
    
    if [ -z "$proto_files" ]; then
        log_warn "No .proto files found in ${PROTO_DIR}"
        return 0
    fi
    
    local errors=0
    
    # Validate each proto file
    for proto_file in $proto_files; do
        log_info "Validating: $(basename "$proto_file")"
        
        # Check syntax by compiling to descriptor
        if ! protoc --proto_path="${PROTO_DIR}" --descriptor_set_out=/dev/null "$proto_file" 2>/dev/null; then
            log_error "Syntax error in: $proto_file"
            protoc --proto_path="${PROTO_DIR}" --descriptor_set_out=/dev/null "$proto_file"
            errors=$((errors + 1))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        log_info "All protobuf files are valid!"
        return 0
    else
        log_error "Found $errors validation error(s)"
        return 1
    fi
}

# Check for common issues
check_style() {
    log_info "Checking protobuf style guidelines..."
    
    local proto_files=$(find "${PROTO_DIR}" -name "*.proto")
    local warnings=0
    
    for proto_file in $proto_files; do
        # Check for proper package naming
        if ! grep -q "^package.*\.v[0-9]" "$proto_file"; then
            log_warn "$(basename "$proto_file"): Consider using versioned package naming (e.g., myservice.v1)"
            warnings=$((warnings + 1))
        fi
        
        # Check for go_package option
        if ! grep -q "option go_package" "$proto_file"; then
            log_warn "$(basename "$proto_file"): Missing go_package option"
            warnings=$((warnings + 1))
        fi
    done
    
    if [ $warnings -eq 0 ]; then
        log_info "No style issues found!"
    else
        log_warn "Found $warnings style warning(s)"
    fi
}

# Main function
main() {
    check_protoc
    validate_protos
    check_style
    log_info "Validation completed!"
}

# Run main function
main "$@"