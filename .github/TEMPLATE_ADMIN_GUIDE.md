# Making This Repository a GitHub Template

This guide explains how to enable the "Use this template" feature for this repository.

## For Repository Administrators

### Enable Template Repository Feature

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click on **Settings** tab (you need admin access)

2. **Enable Template Repository**
   - Scroll to the **Template repository** section (near the top of Settings)
   - Check the box ✅ **Template repository**
   - This makes the "Use this template" button visible to all users

### What This Enables

Once enabled, users will see a green **"Use this template"** button at the top of the repository, next to the "Code" button. This allows them to:

- Create a new repository with all the template files
- Start with a clean git history (no commits from the template repo)
- Maintain their own independent repository
- Get future updates if they choose to manually merge them

### Template Configuration Files

This repository includes several files that enhance the template experience:

- **`.github/template.yml`**: Defines template metadata (name, description, labels)
- **`.github/TEMPLATE_SETUP.md`**: Post-creation setup instructions for users
- **`README.md`**: Updated with prominent "Use this template" instructions
- **`.env.example`**: Example environment configuration file

### Repository Settings Recommendations

For the best template experience, consider these additional settings:

1. **Topics/Tags**: Add relevant topics to help users discover this template
   - Go to Settings → About section (top right of main page)
   - Add topics: `robot-framework`, `rpa`, `automation`, `template`, `blueprint`

2. **Description**: Set a clear repository description
   - "A comprehensive Robot Framework blueprint for building RPA automation projects"

3. **Include all branches**: When creating from template, users can choose to include all branches
   - Typically, you want the main/master branch to be clean and ready to use

4. **Visibility**: Decide if this should be public or private
   - Public templates can be used by anyone
   - Private templates can only be used within your organization

### Verifying Template Status

After enabling:

1. Log out or use an incognito window
2. Navigate to the repository
3. You should see the "Use this template" button next to the "Code" dropdown

### Template Best Practices

- **Keep it Minimal**: Only include essential files and structure
- **Clear Documentation**: Ensure README.md has clear setup instructions
- **Example Files**: Include `.example` files for configuration
- **Remove Secrets**: Never include actual credentials or API keys
- **Test Regularly**: Periodically create a new repository from the template to ensure it works
- **Version Tags**: Consider using tags/releases for template versions

## For Users Creating from Template

Users who click "Use this template" will be guided through:

1. Naming their new repository
2. Choosing visibility (public/private/internal)
3. Optionally including all branches

After creation, they should follow the instructions in `README.md` and `.github/TEMPLATE_SETUP.md`.

## Support

If you encounter issues with the template feature:

- Check GitHub's [Template Repositories Documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)
- Ensure you have admin access to the repository
- Verify the repository is not a fork (forks cannot be templates)

---

**Note**: This file is for maintainers only and can be removed if desired, as it doesn't affect the template functionality.
