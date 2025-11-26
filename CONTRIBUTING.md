# Contributing to Robot Automation Blueprint

Thank you for your interest in contributing! This document provides guidelines for contributing to the Robot Automation Blueprint project.

## For Template Users

If you've created a repository from this template and want to contribute improvements back:

1. **Create a fork** of the original blueprint repository (not your template-created repo)
2. **Make your improvements** in the fork
3. **Submit a pull request** to the blueprint repository

Your contributions help improve the template for all users!

## For Direct Contributors

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/robot-automation-blueprint.git
   cd robot-automation-blueprint
   ```
3. **Set up the development environment**:
   ```bash
   ./setup.sh
   ```

## Development Workflow

### 1. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b bugfix/issue-description
```

### 2. Make Your Changes

Follow the project structure:
- **Tests**: Add test suites in the root directory as `rpa_*.robot` files
- **Resources**: Add reusable keywords in `resources/` directory
- **Libraries**: Add Python libraries in `libraries/` directory
- **Data**: Add sample data files in `data/` directory

### 3. Test Your Changes

Run tests locally before committing:
```bash
# Run all tests
./run_tests.sh

# Run with visible browser
./run_tests.sh --browser

# Run specific test
./run_tests.sh --test "Your Test Name"
```

### 4. Commit Your Changes

Follow conventional commit messages:
```bash
git add .
git commit -m "feat: add new keyword for form handling"
# or
git commit -m "fix: resolve browser timeout issue"
# or
git commit -m "docs: update README with new examples"
```

Commit message types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `style`: Code style changes (formatting)
- `chore`: Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Coding Standards

### Robot Framework Guidelines

1. **Use descriptive test names**:
   ```robot
   Test Create Item With High Priority
   Test Submit Form With Required Fields
   ```

2. **Add documentation to test cases**:
   ```robot
   *** Test Cases ***
   Test Create Item
       [Documentation]    Verify item creation through form submission
       [Tags]    form    create    smoke
   ```

3. **Use tags appropriately**:
   - `smoke` - Quick validation tests
   - `form` - Form-related tests
   - `api` - API tests
   - `ui` - Browser UI tests
   - `data` - Data handling tests
   - `validation` - Validation tests

4. **Keep keywords reusable**:
   - Place common keywords in `resources/common.robot`
   - Create specific resource files for related keywords
   - Use meaningful parameter names

5. **Use proper indentation**:
   - 4 spaces for Robot Framework files
   - Align arguments vertically for readability

### Python Library Guidelines

1. **Follow PEP 8** style guide

2. **Document your functions**:
   ```python
   def create_record(self, endpoint: str, data: Dict[str, Any]) -> Dict[str, Any]:
       """Create a new record via API.
       
       Args:
           endpoint: API endpoint name
           data: Dictionary containing the record data
           
       Returns:
           Dictionary containing the created record
       """
   ```

3. **Use type hints** where appropriate

4. **Handle errors gracefully**:
   ```python
   try:
       response.raise_for_status()
   except requests.exceptions.HTTPError as e:
       self.logger.error(f"HTTP error: {e}")
       raise
   ```

### Test Data Guidelines

1. **Never commit sensitive data**:
   - Use `.env` for credentials
   - Use sample/mock data in `data/` directory
   - Mark sensitive files in `.gitignore`

2. **Provide sample data files**:
   - Name sample files with `sample_` prefix
   - Document required data format in README

## Pull Request Guidelines

### Before Submitting

- [ ] Tests pass locally (`./run_tests.sh`)
- [ ] Code follows project style guidelines
- [ ] Documentation is updated if needed
- [ ] Commit messages follow conventional format
- [ ] No sensitive data in commits

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
Describe how you tested your changes

## Checklist
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Follows coding standards
```

## Issue Reporting

### Creating an Issue

Include the following information:

1. **Issue Type**: Bug, Feature Request, Question
2. **Description**: Clear description of the issue
3. **Steps to Reproduce** (for bugs):
   - Step 1
   - Step 2
   - Expected result
   - Actual result
4. **Environment**:
   - OS and version
   - Python version
   - Robot Framework version
5. **Logs/Screenshots**: Attach relevant logs or screenshots

## Additional Resources

- [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [Browser Library Documentation](https://robotframework-browser.org/)
- [RPA Framework Documentation](https://rpaframework.org/)

## Questions?

If you have questions:
1. Check existing issues
2. Review documentation
3. Create a new issue with your question

Thank you for contributing! 🚀
