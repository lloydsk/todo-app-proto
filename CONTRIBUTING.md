# Contributing to Todo App Protocol Buffers

Thank you for your interest in contributing to the Todo App Protocol Buffers! This document provides guidelines and information for contributors.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Making Changes](#making-changes)
- [Submitting Changes](#submitting-changes)
- [Versioning](#versioning)

## Code of Conduct

Please be respectful and professional in all interactions. We're here to build great software together.

## Getting Started

### Prerequisites

1. **Protocol Buffer Compiler (protoc)**
   ```bash
   # macOS
   brew install protobuf
   
   # Ubuntu/Debian
   sudo apt-get install protobuf-compiler
   ```

2. **Go and Protocol Buffer Plugins**
   ```bash
   # Install Go (1.21+)
   # Then install plugins
   go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
   go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
   ```

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/todo-app-proto.git
   cd todo-app-proto
   ```
3. Validate your setup:
   ```bash
   make validate
   make generate
   ```

## Development Workflow

### Branch Strategy

- `master` - Production releases, protected branch
- `feature/*` - New features and enhancements
- `fix/*` - Bug fixes
- `docs/*` - Documentation updates

### Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following these guidelines:
   - Follow the [Proto Style Guide](#proto-style-guide)
   - Add comprehensive comments
   - Consider backward compatibility

3. **Validate your changes:**
   ```bash
   make validate
   make generate
   ```

4. **Test with consuming services** (if available)

## Proto Style Guide

### File Organization
```
proto/
└── todo/
    └── v1/
        └── todo.proto    # Main service definitions
```

### Naming Conventions

- **Services**: PascalCase (e.g., `TodoService`)
- **Methods**: PascalCase (e.g., `CreateTask`)
- **Messages**: PascalCase (e.g., `CreateTaskRequest`)
- **Fields**: snake_case (e.g., `task_id`)
- **Enums**: SCREAMING_SNAKE_CASE (e.g., `TASK_STATUS_OPEN`)

### Field Guidelines

1. **Always use optional for new fields** unless truly required
2. **Never reuse field numbers**
3. **Use consistent field numbering:**
   - 1-15: Most frequently used fields (1 byte encoding)
   - 16-2047: Less frequent fields (2 byte encoding)
4. **Mark deleted fields as reserved:**
   ```protobuf
   message Task {
     reserved 2, 15, 9 to 11;
     reserved "old_field_name";
     
     string id = 1;
     string title = 3;  // Field 2 was deleted
   }
   ```

### Documentation
- Add comprehensive comments for all services, methods, and messages
- Explain business logic and constraints
- Document expected behavior and error conditions

## Submitting Changes

### Pull Request Process

1. **Update documentation** if needed
2. **Ensure CI passes:**
   - Validation checks
   - Code generation
   - Security scans

3. **Create pull request** with:
   - Clear title and description
   - Reference related issues
   - Complete the PR template checklist

4. **Address review feedback** promptly

### Review Criteria

Pull requests are reviewed for:
- **Backward compatibility** - No breaking changes without major version bump
- **Code quality** - Following style guide and best practices  
- **Documentation** - Adequate comments and updates
- **Testing** - Validation passes and generated code compiles

## Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (v2.0.0): Breaking changes
  - Removing fields, services, or methods
  - Changing field types incompatibly
  - Renaming services or methods

- **MINOR** (v1.1.0): Backward-compatible additions
  - Adding new services or methods
  - Adding optional fields
  - Adding new enum values

- **PATCH** (v1.0.1): Non-functional changes
  - Documentation updates
  - Comment changes
  - Build improvements

### Release Process

1. **Create release PR** updating version references
2. **Merge to master** after approval
3. **Create git tag** with version (e.g., `v1.2.3`)
4. **GitHub Actions** automatically:
   - Validates changes
   - Generates code
   - Creates GitHub release
   - Publishes artifacts

## Questions?

- Check existing [issues](../../issues) and [discussions](../../discussions)
- Review the [development documentation](docs/development.md)
- Create a new issue for questions or clarifications

Thank you for contributing! 🚀