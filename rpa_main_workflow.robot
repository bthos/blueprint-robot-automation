*** Settings ***
Documentation     Main automation workflow template
...               CUSTOMIZE: Rename this file and update for your specific automation
Resource          resources/common.robot
Resource          resources/data_preparation.robot
Resource          resources/app_navigation.robot
Resource          resources/form_sample.robot
Resource          resources/helpers.robot
Library           libraries/ErrorHandler.py
Library           Collections
Suite Setup       Setup Test Suite
Suite Teardown    Cleanup Test Suite
Test Setup        Setup Test Environment
Test Teardown     Test Teardown With Screenshot

*** Variables ***
${HEADLESS}          %{BROWSER_HEADLESS=True}
${CLOSE_BROWSER}     %{CLOSE_BROWSER_AFTER_TEST=True}
${EXCEL_FILE}        %{EXCEL_FILE_PATH=./data/sample_records.xlsx}
${DATA_SOURCE}       %{DATA_SOURCE=excel}    # Options: excel, sharepoint

*** Keywords ***
Setup Test Suite
    [Documentation]    Setup for test suite
    Log    Starting Automation Test Suite
    Log    CLOSE_BROWSER variable value: ${CLOSE_BROWSER}    console=True
    # Initialize Browser library
    TRY
        ${result}=    Run Keyword And Return Status    Get Browser Catalog
        IF    not ${result}
            Log    Browser may need initialization    WARN
        END
    EXCEPT
        Log    Browser library initialization    DEBUG
    END

Cleanup Test Suite
    [Documentation]    Cleanup after test suite
    Cleanup Test Environment    close_browser=${CLOSE_BROWSER}

Test Teardown With Screenshot
    [Documentation]    Teardown with screenshot on failure
    Run Keyword If Test Failed    Take Screenshot On Failure
    # Only close browser if CLOSE_BROWSER is True
    IF    '${CLOSE_BROWSER}' == 'True'
        TRY
            Close Application
        EXCEPT
            Log    Browser already closed    DEBUG
        END
    ELSE
        Log    Keeping browser open as CLOSE_BROWSER_AFTER_TEST=False    console=True
    END

*** Test Cases ***
Main Workflow Example
    [Documentation]    Example automation workflow template
    ...    CUSTOMIZE: Update steps for your specific automation
    ...    
    ...    Workflow Steps:
    ...    1. Load data from configured source
    ...    2. Login to application
    ...    3. Navigate to target page
    ...    4. Fill form with data
    ...    5. Submit and verify
    [Tags]    main    workflow    example
    
    TRY
        # Step 1: Load data from configured source
        Log    Step 1: Load data from ${DATA_SOURCE}    console=True
        ${record}    ${identifier}    ${source}=    Load Deployment Data    ${DATA_SOURCE}    ${EXCEL_FILE}
        
        # Log record summary for debugging
        Log Record Summary    ${record}
        
        # Step 2: Login to application
        Log    Step 2: Login to application    console=True
        Open Application And Login    headless=${HEADLESS}    step=02
        
        # Verify successful login
        ${url}=    Get Url
        Log    Current URL: ${url}    console=True
        
        # Step 3: Navigate to target page
        Log    Step 3: Navigate to target page    console=True
        # CUSTOMIZE: Update navigation for your application
        # Navigate To Page    Your Page Name    step=03
        Sleep    2s
        Take Screenshot    step03_navigated
        
        # Step 4: Fill form with data
        Log    Step 4: Fill form with data    console=True
        # CUSTOMIZE: Update form filling for your application
        # Fill All Form Fields    ${record}    step=04
        
        # Step 5: Submit and verify
        Log    Step 5: Submit and verify    console=True
        # CUSTOMIZE: Update submission and verification
        # Submit Form    step=05
        # ${success}=    Verify Form Submission    step=05
        # ${record_id}=    Get Created Record ID    step=05
        
        # Step 6: Write result back to data source (optional)
        # CUSTOMIZE: Update field name for your "processed" indicator
        # Write Result To Data Source    ${source}    ${identifier}    Result ID    ${record_id}    ${EXCEL_FILE}
        
        Log    Workflow completed successfully    console=True
        Log Audit Entry    Main Workflow    SUCCESS
        
        # Cleanup data source
        Cleanup Data Source    ${source}
        
        # Keep browser open briefly to see result
        Sleep    3s
        
        # Close browser based on configuration
        IF    '${CLOSE_BROWSER}' == 'True'
            Log    Closing browser    console=True
            Close Application
        ELSE
            Log    Keeping browser open for review    console=True
            Sleep    30s
        END
        
    EXCEPT    AS    ${error}
        Log Audit Entry    Main Workflow    FAILURE
        
        # Cleanup data source if it was loaded
        ${source_loaded}=    Run Keyword And Return Status    Variable Should Exist    ${source}
        IF    ${source_loaded}
            TRY
                Cleanup Data Source    ${source}
            EXCEPT
                Log    Failed to cleanup data source    DEBUG
            END
        END
        
        # Take screenshot if browser was opened
        ${browser_opened}=    Run Keyword And Return Status    Get Browser Catalog
        IF    ${browser_opened}
            Handle Error    Test failed: ${error}    take_screenshot=${True}
        ELSE
            Log    Test failed before browser opened: ${error}    ERROR
        END
        
        # Close browser
        IF    '${CLOSE_BROWSER}' == 'True'
            TRY
                Close Application
            EXCEPT
                Log    Browser already closed    DEBUG
            END
        END
        
        Fail    ${error}
    END

Data Validation Test
    [Documentation]    Test that validates data loading without running full workflow
    [Tags]    data    validation    smoke
    
    Log    Testing data load from ${DATA_SOURCE}    console=True
    
    ${record}    ${identifier}    ${source}=    Load Deployment Data    ${DATA_SOURCE}    ${EXCEL_FILE}
    
    # Validate record has data
    ${keys}=    Get Dictionary Keys    ${record}
    ${key_count}=    Get Length    ${keys}
    Should Be True    ${key_count} > 0    msg=Record should have at least one field
    
    Log Record Summary    ${record}
    
    Log    Data validation passed    console=True
    
    Cleanup Data Source    ${source}
