#!/bin/bash

# Robot Automation Blueprint - Setup Script
# This script sets up the Robot Framework RPA environment

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Robot Automation Blueprint - Setup Script"
echo "=========================================="
echo ""

# Check Python version
echo -e "${YELLOW}Checking Python version...${NC}"
PYTHON_CMD=""

if command -v python3.10 &> /dev/null; then
    PYTHON_CMD="python3.10"
elif command -v python3.11 &> /dev/null; then
    PYTHON_CMD="python3.11"
elif command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
elif command -v python3 &> /dev/null; then
    # Use Python itself for version comparison (more portable than bc)
    PYTHON_CMD_CHECK=$(python3 -c "import sys; print('ok' if sys.version_info >= (3, 10) else 'no')" 2>/dev/null || echo "no")
    if [ "$PYTHON_CMD_CHECK" = "ok" ]; then
        PYTHON_CMD="python3"
    fi
fi

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}Error: Python 3.10 or higher is required${NC}"
    echo "Please install Python 3.10+ and try again"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version)
echo -e "${GREEN}✓ Found: $PYTHON_VERSION${NC}"
echo ""

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
if [ -d "venv" ]; then
    echo "Virtual environment already exists"
    read -p "Do you want to recreate it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf venv
        $PYTHON_CMD -m venv venv
        echo -e "${GREEN}✓ Virtual environment recreated${NC}"
    fi
else
    $PYTHON_CMD -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
fi
echo ""

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi
echo -e "${GREEN}✓ Virtual environment activated${NC}"
echo ""

# Upgrade pip
echo -e "${YELLOW}Upgrading pip...${NC}"
pip install --upgrade pip
echo -e "${GREEN}✓ pip upgraded${NC}"
echo ""

# Install requirements
echo -e "${YELLOW}Installing Python packages...${NC}"
pip install -r requirements.txt
echo -e "${GREEN}✓ Python packages installed${NC}"
echo ""

# Initialize Playwright browsers
echo -e "${YELLOW}Initializing Playwright browsers...${NC}"
rfbrowser init
echo -e "${GREEN}✓ Playwright browsers initialized${NC}"
echo ""

# Create .env file
echo -e "${YELLOW}Setting up environment configuration...${NC}"
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created from template${NC}"
    echo ""
    echo -e "${YELLOW}IMPORTANT: Please edit .env file with your credentials${NC}"
else
    echo ".env file already exists"
fi
echo ""

# Create necessary directories
echo -e "${YELLOW}Creating project directories...${NC}"
mkdir -p reports logs data
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# Summary
echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file with your credentials:"
echo "   - APP_URL (your target application URL)"
echo "   - SSO_USERNAME (your login username)"
echo "   - SSO_PASSWORD (your login password)"
echo ""
echo "2. Place your data file in the data/ directory"
echo "   (or update EXCEL_FILE_PATH in .env)"
echo ""
echo "3. Customize the automation:"
echo "   - Update resources/ files for your application"
echo "   - Modify rpa_main_workflow.robot for your workflow"
echo ""
echo "4. Run the automation:"
echo "   robot --outputdir reports rpa_main_workflow.robot"
echo ""
echo "For help, see README.md"
echo ""
