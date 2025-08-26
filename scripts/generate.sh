#!/bin/bash

set -euo pipefail

# Script to generate protobuf code for various languages
# Usage: ./generate.sh [language]
# Supported languages: go, all

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROTO_DIR="${REPO_ROOT}/proto"
OUTPUT_DIR="${REPO_ROOT}/gen"

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
        log_info "On macOS: brew install protobuf"
        log_info "On Ubuntu: sudo apt-get install protobuf-compiler"
        exit 1
    fi
    log_info "Using protoc version: $(protoc --version)"
}

# Generate Go code
generate_go() {
    log_info "Generating Go protobuf code..."
    
    # Check if protoc-gen-go is installed
    if ! command -v protoc-gen-go &> /dev/null; then
        log_error "protoc-gen-go is not installed."
        log_info "Install with: go install google.golang.org/protobuf/cmd/protoc-gen-go@latest"
        exit 1
    fi
    
    # Check if protoc-gen-go-grpc is installed
    if ! command -v protoc-gen-go-grpc &> /dev/null; then
        log_error "protoc-gen-go-grpc is not installed."
        log_info "Install with: go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"
        exit 1
    fi
    
    # Create output directory
    GO_OUTPUT="${OUTPUT_DIR}/go"
    mkdir -p "${GO_OUTPUT}"
    
    # Generate Go protobuf and gRPC code
    protoc \
        --proto_path="${PROTO_DIR}" \
        --go_out="${GO_OUTPUT}" \
        --go_opt=paths=source_relative \
        --go-grpc_out="${GO_OUTPUT}" \
        --go-grpc_opt=paths=source_relative \
        "${PROTO_DIR}/todo/v1/todo.proto"
    
    # Create or update go.mod for generated code
    create_go_mod
    
    log_info "Go code generated in ${GO_OUTPUT}/todo/v1/"
}

# Create go.mod file for generated Go code
create_go_mod() {
    local GO_OUTPUT="${OUTPUT_DIR}/go"
    local GO_MOD_FILE="${GO_OUTPUT}/go.mod"
    
    if [ ! -f "${GO_MOD_FILE}" ]; then
        log_info "Creating go.mod for generated Go code..."
        
        cat > "${GO_MOD_FILE}" << EOF
module github.com/todo-app/todo-app-proto/gen/go

go 1.21

require (
	google.golang.org/grpc v1.62.1
	google.golang.org/protobuf v1.32.0
)

require (
	github.com/golang/protobuf v1.5.3 // indirect
	golang.org/x/net v0.20.0 // indirect
	golang.org/x/sys v0.16.0 // indirect
	golang.org/x/text v0.14.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20240123012728-ef4313101c80 // indirect
)
EOF
        
        # Initialize go.sum if go is available
        if command -v go &> /dev/null; then
            cd "${GO_OUTPUT}" && go mod tidy && cd - > /dev/null
        fi
        
        log_info "go.mod created successfully"
    else
        log_info "go.mod already exists, skipping creation"
    fi
}

# Clean output directory
clean() {
    log_info "Cleaning output directory..."
    rm -rf "${OUTPUT_DIR}"
}

# Main function
main() {
    check_protoc
    
    local language="${1:-all}"
    
    case "$language" in
        "go")
            clean
            generate_go
            ;;
        "all")
            clean
            generate_go
            # Add other languages here as needed
            ;;
        *)
            log_error "Unsupported language: $language"
            log_info "Supported languages: go, all"
            exit 1
            ;;
    esac
    
    log_info "Code generation completed successfully!"
}

# Run main function with all arguments
main "$@"