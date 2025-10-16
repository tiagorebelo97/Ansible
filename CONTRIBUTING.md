# Contributing to Ansible IaC Repository

Thank you for considering contributing to this repository! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and professional
- Focus on constructive feedback
- Help maintain a welcoming environment

## How to Contribute

### Reporting Issues

1. Check if the issue already exists
2. Provide detailed information:
   - Ansible version
   - Operating system
   - Error messages
   - Steps to reproduce

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add some feature'`)
6. Push to the branch (`git push origin feature/your-feature`)
7. Open a Pull Request

## Development Guidelines

### Ansible Best Practices

1. **Use meaningful names** for plays, tasks, and variables
2. **Document your code** with comments where necessary
3. **Follow YAML standards**:
   - Use 2 spaces for indentation
   - Use `---` to start YAML files
   - Quote strings when necessary
4. **Use tags** to allow selective execution
5. **Make idempotent tasks** - tasks should be safe to run multiple times
6. **Use roles** for reusable components
7. **Avoid hardcoding** - use variables instead

### Directory Structure

- `playbooks/` - Main playbooks
- `roles/` - Reusable roles
- `inventory/` - Inventory files and variables
- `templates/` - Jinja2 templates
- `files/` - Static files

### Testing

Before submitting:

1. **Syntax check**:
   ```bash
   make syntax
   ```

2. **Lint your code** (if ansible-lint is available):
   ```bash
   make lint
   ```

3. **Test connectivity**:
   ```bash
   make ping
   ```

4. **Dry run**:
   ```bash
   make check
   ```

### Commit Messages

Use clear and descriptive commit messages:

```
Add role for OpenShift worker configuration

- Configure kubelet settings
- Set up container runtime
- Add firewall rules
```

### Variable Naming

- Use lowercase with underscores: `cluster_name`
- Be descriptive: `openshift_version` not `version`
- Group related variables: `master_vcpus`, `master_memory`

### Role Development

When creating new roles:

1. Use `ansible-galaxy init rolename` to create structure
2. Include `meta/main.yml` with dependencies
3. Document role in `README.md`
4. Provide sensible defaults in `defaults/main.yml`
5. Use handlers for service restarts

### Documentation

- Update README.md for significant changes
- Document new variables in role defaults
- Add comments for complex logic
- Include examples where helpful

## Pull Request Process

1. Update documentation for any user-facing changes
2. Ensure all tests pass
3. Follow the pull request template
4. Request review from maintainers
5. Address review feedback

## Questions?

Open an issue for questions or discussions.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
