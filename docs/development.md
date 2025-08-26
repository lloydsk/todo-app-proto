# Protocol Buffer Development Workflow

This document outlines the development workflow for the Todo App Protocol Buffers.

## Prerequisites

### Required Tools

1. **Protocol Buffer Compiler (protoc)**
   ```bash
   # macOS
   brew install protobuf
   
   # Ubuntu/Debian
   sudo apt-get install protobuf-compiler
   ```

2. **Go Protocol Buffer Plugins**
   ```bash
   go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
   go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
   ```

## Development Process

### 1. Making Changes

1. **Edit proto files** in the `proto/` directory
2. **Follow naming conventions**:
   - Services: PascalCase (e.g., `TodoService`)
   - Methods: PascalCase (e.g., `CreateTask`)
   - Messages: PascalCase (e.g., `CreateTaskRequest`)
   - Fields: snake_case (e.g., `task_id`)

### 2. Validation

Always validate your changes before committing:

```bash
./scripts/validate.sh
```

### 3. Code Generation

Generate code to ensure everything compiles:

```bash
# Generate Go code
./scripts/generate.sh go

# Generate all supported languages
./scripts/generate.sh all
```

### 4. Testing Changes

Test the generated code with your consuming services:

```bash
# In your service directory, update the proto dependency
go mod edit -replace github.com/todo-app/todo-app-proto/gen/go=../todo-app-proto/gen/go
go mod tidy
```

## Versioning Guidelines

### Semantic Versioning

- **MAJOR** (v2.0.0): Breaking changes
  - Removing fields, services, or methods
  - Changing field types incompatibly
  - Renaming services or methods

- **MINOR** (v1.1.0): Backward-compatible additions
  - Adding new services or methods
  - Adding optional fields
  - Adding new enum values (at the end)

- **PATCH** (v1.0.1): Non-functional changes
  - Documentation updates
  - Comment changes
  - Code style improvements

### Backward Compatibility Rules

1. **Never delete fields** - mark as deprecated instead
2. **Never change field numbers** - they are part of the wire format
3. **Never change field types** - except for compatible types (int32 ↔ int64, etc.)
4. **Always add new fields as optional**
5. **Add new enum values at the end**

## Release Process

### Creating a Release

1. **Ensure all changes are committed**
   ```bash
   git status  # Should be clean
   ```

2. **Run the release script**
   ```bash
   ./scripts/release.sh v1.2.3
   ```

3. **Push the tag**
   ```bash
   git push origin v1.2.3
   ```

4. **Create GitHub release** with changelog

### Updating Consuming Services

After releasing a new version:

1. **Update the proto dependency**
   ```bash
   # In consuming service directory
   go get github.com/todo-app/todo-app-proto/gen/go@v1.2.3
   ```

2. **Update imports if needed**
3. **Test thoroughly**
4. **Deploy updated services**

## Best Practices

### Proto Style Guide

1. **File Organization**
   ```
   proto/
   └── todo/
       └── v1/
           └── todo.proto
   ```

2. **Package Naming**
   ```protobuf
   package todo.v1;
   option go_package = "github.com/todo-app/todo-app-proto/gen/go/todo/v1";
   ```

3. **Service Definition**
   ```protobuf
   service TodoService {
     rpc CreateTask(CreateTaskRequest) returns (CreateTaskResponse);
     rpc GetTask(GetTaskRequest) returns (GetTaskResponse);
   }
   ```

4. **Message Naming**
   ```protobuf
   message CreateTaskRequest {
     string title = 1;
     optional string description = 2;
   }
   
   message CreateTaskResponse {
     Task task = 1;
   }
   ```

### Field Numbering

- **1-15**: Most frequently used fields (1 byte encoding)
- **16-2047**: Less frequent fields (2 byte encoding)
- **19000-19999**: Reserved for Protocol Buffers implementation
- **Reserved**: Mark deleted field numbers as reserved

```protobuf
message Task {
  reserved 2, 15, 9 to 11;
  reserved "old_field_name";
  
  string id = 1;
  string title = 3;  // Field 2 was deleted
}
```

## Troubleshooting

### Common Issues

1. **"protoc: command not found"**
   - Install Protocol Buffer compiler (see Prerequisites)

2. **"protoc-gen-go: command not found"**
   - Install Go protobuf plugins (see Prerequisites)
   - Ensure `$GOPATH/bin` is in your `$PATH`

3. **Import path issues**
   - Check `go_package` option in proto files
   - Verify module paths in consuming services

### Getting Help

- Check the [Protocol Buffers documentation](https://protobuf.dev/)
- Review the [gRPC Go documentation](https://grpc.io/docs/languages/go/)
- Ask in team channels for project-specific questions