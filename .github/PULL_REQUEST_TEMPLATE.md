# Protocol Buffer Changes

## Summary
<!-- Brief description of the changes -->

## Type of Change
- [ ] New service definition
- [ ] New RPC methods
- [ ] New message types
- [ ] Field additions (backward compatible)
- [ ] Field modifications (potentially breaking)
- [ ] Documentation updates
- [ ] Build/tooling improvements

## Breaking Changes
- [ ] This PR contains breaking changes
- [ ] This PR is backward compatible

<!-- If breaking changes, describe the impact and migration path -->

## Validation
- [ ] `./scripts/validate.sh` passes
- [ ] `./scripts/generate.sh all` generates code successfully
- [ ] Generated Go code compiles without errors
- [ ] All consuming services have been tested with these changes

## Proto Changes Checklist
- [ ] New fields are added with unique field numbers
- [ ] Field numbers are not reused from deleted fields
- [ ] New enum values are added at the end
- [ ] Required fields are avoided (use optional instead)
- [ ] Comments and documentation are updated

## Version Impact
- [ ] PATCH - Documentation or non-functional changes
- [ ] MINOR - Backward compatible additions
- [ ] MAJOR - Breaking changes

## Testing
<!-- Describe how these changes have been tested -->

## Additional Notes
<!-- Any additional information for reviewers -->