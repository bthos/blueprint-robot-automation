# Template Setup Instructions

Thank you for using the Robot Automation Blueprint! 🎉

## Next Steps

Now that you've created your repository from this template, follow these steps to get started:

### 1. Clone Your New Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### 2. Run the Setup Script

The setup script will:
- Create a Python virtual environment
- Install all required dependencies
- Initialize Playwright browsers
- Set up the project structure

```bash
./setup.sh
```

### 3. Configure Your Environment

Create a `.env` file with your application credentials:

```bash
cp .env.example .env
```

Edit `.env` with your specific configuration:
- `APP_URL`: Your target application URL
- `SSO_USERNAME` and `SSO_PASSWORD`: Your credentials
- `DATA_SOURCE`: Choose between 'excel' or 'sharepoint'
- Browser settings and other configuration

### 4. Customize for Your Application

- **Resources**: Update files in `resources/` to match your application's UI elements
- **Libraries**: Modify Python libraries in `libraries/` for your specific API
- **Test Data**: Add your data files to the `data/` directory
- **Main Workflow**: Adapt `rpa_main_workflow.robot` to your automation needs

### 5. Run Your First Test

```bash
# Activate virtual environment
source venv/Scripts/activate  # Windows Git Bash
# source venv/bin/activate  # Linux/Mac

# Run the automation
robot --outputdir reports rpa_main_workflow.robot
```

## Documentation

For detailed documentation, see the main [README.md](../README.md) file.

## Need Help?

- Check the [Troubleshooting](../README.md#troubleshooting) section
- Review [Best Practices](../README.md#best-practices)
- See [Contributing Guidelines](../CONTRIBUTING.md)

Happy Automating! 🤖
