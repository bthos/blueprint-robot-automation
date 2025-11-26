# Template Repository Preparation Checklist

Use this checklist to ensure the repository is ready to be used as a GitHub template.

## ✅ Repository Setup

- [ ] **Enable Template Repository**
  - Go to Settings → Check "Template repository"
  
- [ ] **Set Repository Description**
  - Clear, concise description of what the template does
  - Example: "A comprehensive Robot Framework blueprint for building RPA automation projects"

- [ ] **Add Topics/Tags**
  - Go to About section → Add topics
  - Suggested: `robot-framework`, `rpa`, `automation`, `template`, `blueprint`, `playwright`

- [ ] **License File**
  - Verify LICENSE file exists and is appropriate
  - Consider MIT or Apache 2.0 for templates

## ✅ Documentation Files

- [ ] **README.md**
  - Clear "Use this template" section at the top
  - Badge/button linking to `/generate` endpoint
  - Quick start instructions for template users
  - Prerequisites clearly listed
  - Customization guide included

- [ ] **CONTRIBUTING.md**
  - Instructions for contributing back to the template
  - Clear distinction between template users and contributors

- [ ] **TEMPLATE_SETUP.md**
  - Step-by-step post-creation instructions
  - Located in `.github/` directory

- [ ] **TEMPLATE_ADMIN_GUIDE.md**
  - Guide for enabling and managing template features
  - Can be removed before making public if desired

## ✅ Configuration Files

- [ ] **`.env.example`**
  - All sensitive values are placeholders
  - Clear comments explaining each variable
  - No actual credentials or secrets

- [ ] **`.gitignore`**
  - Appropriate ignore patterns for the project type
  - Excludes secrets, credentials, local configs
  - Excludes build artifacts and dependencies

- [ ] **`template.yml`** (optional)
  - Defines template metadata
  - Located in `.github/` directory

## ✅ Code Quality

- [ ] **No Hardcoded Secrets**
  - Search for API keys, passwords, tokens
  - Ensure all use environment variables

- [ ] **No Personal Information**
  - Remove personal email addresses
  - Remove organization-specific URLs
  - Replace with placeholders or examples

- [ ] **Working Examples**
  - Sample files demonstrate best practices
  - Example data files are included
  - All scripts run successfully after setup

- [ ] **Dependencies**
  - `requirements.txt` is up to date
  - Version pins are appropriate (not too strict)
  - All dependencies are necessary

## ✅ Scripts and Automation

- [ ] **Setup Script**
  - `setup.sh` runs without errors
  - Creates virtual environment
  - Installs all dependencies
  - Works on intended platforms (Windows/Linux/Mac)

- [ ] **Test Scripts**
  - Test runners work out of the box
  - Sample tests pass or have clear TODO markers

## ✅ Repository Settings

- [ ] **Default Branch**
  - Main branch is clean and ready to use
  - No work-in-progress commits

- [ ] **Branch Protection**
  - Consider protecting main branch
  - Require PR reviews for changes

- [ ] **Issues Template**
  - Consider adding issue templates
  - Helps users report problems correctly

- [ ] **Pull Request Template**
  - Helps contributors submit good PRs

## ✅ Pre-Publication Testing

- [ ] **Fresh Clone Test**
  - Clone to a new directory
  - Run setup script
  - Verify everything works

- [ ] **Template Creation Test**
  - Create a test repository from the template
  - Follow setup instructions
  - Verify new repository works independently

- [ ] **Cross-Platform Test**
  - Test on Windows (Git Bash)
  - Test on Linux
  - Test on macOS (if applicable)

## ✅ Optional Enhancements

- [ ] **GitHub Actions Workflows**
  - CI/CD pipeline examples
  - Automated testing
  - Consider making these optional

- [ ] **VS Code Settings**
  - `.vscode/` folder with recommended settings
  - Extensions recommendations
  - Launch configurations

- [ ] **Docker Support**
  - Dockerfile for containerized execution
  - docker-compose.yml if needed

- [ ] **Release/Version Tags**
  - Tag stable versions
  - Users can reference specific template versions

## Final Steps

Before announcing the template:

1. [ ] Complete all items in this checklist
2. [ ] Review all documentation for clarity
3. [ ] Test the "Use this template" workflow end-to-end
4. [ ] Consider creating a demo video or GIF
5. [ ] Prepare announcement (README, social media, etc.)

---

**Note**: This checklist can be removed from the final template or kept as a reference for maintainers.
