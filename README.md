# Todo App Protocol Buffers

This repository contains the Protocol Buffer definitions for the Todo App microservices ecosystem.

## Structure

```
proto/
└── todo/
    └── v1/
        └── todo.proto    # Main service definitions
scripts/
├── generate.sh           # Generate code for all languages
├── validate.sh          # Validate proto definitions
└── release.sh           # Create versioned releases
docs/
└── development.md       # Development workflow
```

## Supported Languages

- Go (with gRPC and ConnectRPC support)
- TypeScript/JavaScript (future)
- Python (future)

## ConnectRPC Support

This repository generates both traditional gRPC and ConnectRPC clients. ConnectRPC allows your services to be accessible via:
- gRPC protocol (binary, efficient)  
- HTTP/1.1 and HTTP/2 with JSON (web-friendly)
- Same service implementation handles both protocols

## Usage

### Generate Go Code

```bash
./scripts/generate.sh go
```

### Validate Definitions

```bash
./scripts/validate.sh
```

## Versioning

This repository follows semantic versioning. Protocol buffer changes are versioned using:

- **MAJOR**: Breaking changes to existing APIs
- **MINOR**: New services, methods, or backward-compatible fields
- **PATCH**: Documentation, comments, or non-functional changes

## Development Workflow

See [docs/development.md](docs/development.md) for detailed development guidelines.