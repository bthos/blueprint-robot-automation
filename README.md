# Robot Automation Blueprint

A Robot Framework-based RPA blueprint for creating automation projects that interact with web applications through UI and API automation. This template provides a solid foundation for building enterprise automation solutions.

## 🚀 Use This Template

**Ready to start your automation project?** Click the **"Use this template"** button at the top of this repository to create a new repository based on this blueprint.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge)](../../generate)

This will create a new repository in your account with all the blueprint files, allowing you to start customizing immediately without cloning or removing git history.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Customization Guide](#customization-guide)
- [Keywords Reference](#keywords-reference)
- [Reports](#reports)
- [Troubleshooting](#troubleshooting)
- [CI/CD Integration](#cicd-integration)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## Features

- **Data Input**: Read data from Excel files or SharePoint lists
- **UI Automation**: Browser-based automation using Playwright (Browser Library)
- **API Integration**: REST API wrapper for backend operations
- **Dynamic Templates**: Template-based field generation with conditional logic
- **Comprehensive Testing**: Automated validation and testing
- **Error Handling**: Built-in retry logic and error handling mechanisms
- **Audit Trail**: Complete audit logging of all automation actions
- **Multiple Report Formats**: HTML, JUnit XML, and audit logs
- **SSO Support**: Configurable federated login authentication

## Prerequisites

- **Python 3.10 or higher** (Python 3.13 supported with workarounds)
- **Node.js 18.18.0 or higher** (22.x LTS recommended for Playwright compatibility)
- Valid credentials for your target application
- Git Bash or equivalent shell (for Windows users)

## Quick Start

### Option 1: Use This Template (Recommended)

1. **Click "Use this template"** button at the top of this repository
2. **Name your new repository** and choose visibility (public/private)
3. **Clone your new repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/your-new-repo.git
   cd your-new-repo
   ```
4. **Run the setup script**:
   ```bash
   ./setup.sh
   ```

### Option 2: Manual Clone

If you prefer to clone directly:

```bash
# Clone this blueprint repository
git clone https://github.com/YOUR_ORG/robot-automation-blueprint.git my-automation-project
cd my-automation-project

# Remove the git history to start fresh
rm -rf .git
git init

# Run the setup script
./setup.sh

# Configure credentials
cp .env.example .env
# Edit .env with your credentials
```

### 2. Configure Your Application

Edit `.env` file:
```env
# Target Application Configuration
APP_URL=https://your-application.example.com
SSO_USERNAME=your.email@company.com
SSO_PASSWORD=your-password-here

# Data Source Configuration
DATA_SOURCE=excel
EXCEL_FILE_PATH=./data/sample_records.xlsx

# Browser Configuration
BROWSER_HEADLESS=False
```

### 3. Customize for Your Application

1. **Update Resources**: Modify files in `resources/` to match your application's UI
2. **Update Libraries**: Adapt Python libraries in `libraries/` for your API
3. **Create Test Data**: Add your data files to `data/`
4. **Write Tests**: Create test suites in the root directory

### 4. Run Tests

```bash
# Activate virtual environment
source venv/Scripts/activate  # On Windows Git Bash
# venv\Scripts\activate  # On Windows PowerShell
# source venv/bin/activate  # On Linux/Mac

# Run your automation
robot --outputdir reports rpa_main_workflow.robot

# Run with browser visible
BROWSER_HEADLESS=False robot --outputdir reports rpa_main_workflow.robot
```

## Installation

### Automated Installation

```bash
# Run the setup script (creates venv, installs dependencies, initializes browsers)
./setup.sh
```

### Manual Installation

#### 1. Create Virtual Environment

```bash
# On Windows with Git Bash
python -m venv venv
source venv/Scripts/activate

# On Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

#### 2. Install Dependencies

**Standard Installation (Python 3.10-3.12)**

```bash
pip install -r requirements.txt
rfbrowser init
```

**Python 3.13 Installation**

```bash
# Upgrade pip first
python -m pip install --upgrade pip

# Install pandas with pre-built wheels
pip install pandas --no-build-isolation

# Install core dependencies
pip install robotframework==6.1.1 robotframework-requests==0.9.6 openpyxl==3.1.2 python-dotenv==1.0.0 requests==2.31.0 pyyaml jsonschema==4.20.0

# Install Browser library
pip install robotframework-browser

# Install Excel support libraries
pip install xlrd xlwt xlutils rpaframework-core rpaframework-excel

# Initialize Playwright browsers
rfbrowser init chromium
```

## Configuration

### Environment Variables

Create a `.env` file in the project root (copy from `.env.example`):

```env
# Target Application Configuration
APP_URL=https://your-application.example.com
SSO_USERNAME=your.email@company.com
SSO_PASSWORD=your-password-here

# Data Source Configuration
DATA_SOURCE=excel
EXCEL_FILE_PATH=./data/sample_records.xlsx

# Optional: SharePoint Configuration
SHAREPOINT_SITE_URL=https://your-company.sharepoint.com/sites/yoursite
SHAREPOINT_LIST_NAME=your-list-name

# Optional: External API Configuration
API_URL=https://api.example.com
API_TOKEN=your-api-token-here

# Browser Configuration
BROWSER_HEADLESS=True
BROWSER_TIMEOUT=30

# Retry Configuration
MAX_RETRIES=3
RETRY_DELAY=2

# Logging
LOG_LEVEL=INFO
```

### Required Variables

- `APP_URL` - Target application URL
- `SSO_USERNAME` - SSO/federated login username
- `SSO_PASSWORD` - SSO/federated login password

### Optional Variables

- `DATA_SOURCE` - Data source type: `excel` (default) or `sharepoint`
- `EXCEL_FILE_PATH` - Path to Excel data file
- `BROWSER_HEADLESS` - Run browser in headless mode (default: `True`)
- `BROWSER_TIMEOUT` - Browser timeout in seconds (default: `30`)
- `MAX_RETRIES` - Max retry attempts for operations (default: `3`)
- `LOG_LEVEL` - Logging level: DEBUG, INFO, WARN, ERROR (default: `INFO`)

## Project Structure

```plaintext
robot-automation-blueprint/
├── rpa_main_workflow.robot        # Main automation workflow template
├── resources/                      # Reusable Robot Framework resources
│   ├── common.robot               # Common keywords and variables
│   ├── data_preparation.robot     # Unified data loading interface
│   ├── data_excel.robot           # Excel data handling
│   ├── data_sharepoint.robot      # SharePoint data handling (optional)
│   ├── app_navigation.robot       # Application login and navigation
│   ├── auth_sso.robot             # SSO authentication keywords
│   ├── form_*.robot               # Form filling keywords (modular)
│   └── helpers.robot              # Helper keywords and templates
├── libraries/                      # Python libraries
│   ├── ErrorHandler.py            # Error handling and retry logic
│   └── AppAPI.py                  # REST API wrapper (customize for your app)
├── data/                          # Data files
│   └── sample_records.xlsx        # Sample data file template
├── reports/                       # Generated reports (auto-created)
├── logs/                         # Log files (auto-created)
├── requirements.txt              # Python dependencies
├── .env.example                  # Environment variables template
├── .env                          # Your credentials (never commit!)
├── .gitignore                    # Git ignore patterns
├── setup.sh                      # Setup script
├── run_tests.sh                  # Test runner script
└── README.md                     # This file
```

## Usage

### Running the Main Workflow

```bash
# Activate virtual environment
source venv/Scripts/activate  # Git Bash / Linux/Mac: source venv/bin/activate

# Run with Excel data source (default)
robot --outputdir reports rpa_main_workflow.robot

# Run with browser visible
BROWSER_HEADLESS=False robot --outputdir reports rpa_main_workflow.robot

# Run with SharePoint data source
DATA_SOURCE=sharepoint robot --outputdir reports rpa_main_workflow.robot

# Run specific test by name
robot --outputdir reports --test "Your Test Name" rpa_main_workflow.robot
```

### Additional Test Options

```bash
# Run with specific log level
robot --outputdir reports --loglevel DEBUG rpa_main_workflow.robot

# Generate JUnit XML report
robot --outputdir reports --xunit junit_results.xml rpa_main_workflow.robot

# Run with tags
robot --outputdir reports --include smoke rpa_main_workflow.robot
```

### Viewing Test Reports

After test execution:
```bash
# On Windows
start reports/report.html

# On Linux
xdg-open reports/report.html

# On Mac
open reports/report.html
```

## Customization Guide

### 1. Adapting for Your Application

1. **Update `resources/app_navigation.robot`**:
   - Modify login selectors for your application's login page
   - Update navigation keywords for your application's structure

2. **Create Form Resources**:
   - Add new files like `resources/form_your_section.robot`
   - Define keywords for each form section in your application

3. **Update `libraries/AppAPI.py`**:
   - Modify API endpoints for your application
   - Add methods for your specific API operations

### 2. Adding New Test Suites

Create new `.robot` files following this template:

```robot
*** Settings ***
Documentation     Your test suite description
Resource          resources/common.robot
Resource          resources/app_navigation.robot
Resource          resources/your_form.robot
Library           libraries/ErrorHandler.py
Suite Setup       Setup Test Suite
Suite Teardown    Cleanup Test Suite
Test Setup        Setup Test Environment
Test Teardown     Test Teardown With Screenshot

*** Variables ***
${HEADLESS}          %{BROWSER_HEADLESS=True}

*** Test Cases ***
Your Test Case Name
    [Documentation]    What this test does
    [Tags]    your_tag    another_tag
    
    # Your test steps here
    Open Application And Login
    Navigate To Your Page
    Fill Your Form    ${data}
    Submit Form
    Verify Success
```

### 3. Adding New Keywords

Add reusable keywords in `resources/`:

```robot
*** Keywords ***
Your Custom Keyword
    [Documentation]    What this keyword does
    [Arguments]    ${arg1}    ${arg2}=default_value
    
    # Implementation
    Log    Processing ${arg1}
    Click    ${selector}
    Fill Text    ${input}    ${arg2}
    
    RETURN    ${result}
```

## Keywords Reference

### Common Keywords (`resources/common.robot`)

| Keyword | Description |
|---------|-------------|
| `Setup Test Environment` | Initialize test environment and load configuration |
| `Load Environment Variables` | Load .env file variables |
| `Take Screenshot On Failure` | Auto-screenshot on error |
| `Log Audit Entry` | Log audit entry with action, status, details |
| `Wait And Click Element` | Wait for element and click with retry |
| `Wait And Fill Text` | Wait for element and fill text |

### Data Keywords (`resources/data_excel.robot`)

| Keyword | Description |
|---------|-------------|
| `Read Excel Data` | Read data from Excel file |
| `Load Excel Data` | Load last row from Excel (for processing) |
| `Write Excel Data` | Write data to Excel file |
| `Validate Excel Data` | Validate required columns exist |
| `Filter Excel Data` | Filter data by column value |

### Error Handling (`libraries/ErrorHandler.py`)

| Method | Description |
|--------|-------------|
| `execute_with_retry` | Execute keyword with retry logic |
| `log_audit_entry` | Log action to audit trail |
| `save_audit_log` | Save audit log to JSON file |
| `handle_error` | Handle errors with logging |

## Reports

After test execution, reports are generated in `reports/`:

- **report.html** - Comprehensive HTML report
- **log.html** - Detailed execution log
- **output.xml** - Machine-readable XML results
- **audit_log_*.json** - Audit trail of automation actions
- **screenshots/** - Screenshots from test execution

## Troubleshooting

### Browser/Playwright Issues

**Problem**: "Could not connect to playwright process"

**Solution**:
```bash
# Check Node.js version (must be 18.18.0+)
node --version

# Reinitialize Playwright
rfbrowser init chromium
```

### Missing Dependencies

**Problem**: ModuleNotFoundError

**Solution**:
```bash
source venv/Scripts/activate
pip install -r requirements.txt
```

### Environment Configuration

**Problem**: Tests fail with empty credentials

**Solution**:
1. Verify `.env` file exists
2. Check all required variables are set
3. Ensure no extra spaces in variable values

## CI/CD Integration

### GitHub Actions

The project includes `.github/workflows/robot-tests.yml` for automated testing.

**Setup GitHub Secrets**:
1. Go to repository **Settings > Secrets and variables > Actions**
2. Add required secrets: `APP_URL`, `SSO_USERNAME`, `SSO_PASSWORD`

### Jenkins Integration

```groovy
pipeline {
    agent any
    
    environment {
        APP_URL = credentials('app-url')
        SSO_USERNAME = credentials('sso-username')
        SSO_PASSWORD = credentials('sso-password')
        BROWSER_HEADLESS = 'True'
    }
    
    stages {
        stage('Setup') {
            steps {
                sh 'python3 -m venv venv'
                sh 'source venv/bin/activate && pip install -r requirements.txt'
                sh 'source venv/bin/activate && rfbrowser init chromium'
            }
        }
        
        stage('Test') {
            steps {
                sh 'source venv/bin/activate && robot --outputdir reports *.robot'
            }
        }
    }
    
    post {
        always {
            publishHTML([
                reportDir: 'reports',
                reportFiles: 'report.html',
                reportName: 'Robot Framework Report'
            ])
        }
    }
}
```

## Best Practices

1. **Use service accounts** - Never use personal credentials in automation
2. **Run headless in CI/CD** - Set `BROWSER_HEADLESS=True` for automated runs
3. **Review audit logs** - Check `logs/audit_log_*.json` for compliance
4. **Secure credentials** - Never commit `.env` file to version control
5. **Monitor results** - Review reports after each run
6. **Use version control** - Track changes to test scripts
7. **Document changes** - Keep README and comments updated
8. **Test incrementally** - Validate each step before proceeding
9. **Handle errors gracefully** - Use try/except and proper error messages
10. **Regular maintenance** - Update dependencies periodically

## Security Considerations

- **Never commit** `.env` file or credentials to version control
- Use service accounts with minimum required permissions
- Store credentials securely (use secrets managers in CI/CD)
- Enable audit logging for compliance requirements
- Review and rotate credentials regularly
- Use HTTPS for all connections

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add/update tests as needed
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Additional Resources

- [Robot Framework Documentation](https://robotframework.org)
- [Browser Library Documentation](https://robotframework-browser.org)
- [Playwright Documentation](https://playwright.dev)
- [RPA Framework Documentation](https://rpaframework.org/)

## License

This project is provided as-is for automation purposes.

---

**Template Version**: 1.0.0
