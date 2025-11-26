*** Settings ***
Documentation     Common resource file with reusable keywords and variables
Library           Browser
Library           RequestsLibrary
Library           OperatingSystem
Library           Collections
Library           String
Library           DateTime
Library           ../libraries/ErrorHandler.py
Library           ../libraries/AppAPI.py

*** Variables ***
${BROWSER_TIMEOUT}        30s
${RETRY_DELAY}            2s
${MAX_RETRIES}            3
${SCREENSHOT_DIR}         ${CURDIR}/../reports/screenshots

*** Keywords ***
Setup Test Environment
    [Documentation]    Initialize test environment and load configuration
    ${env_loaded}=    Load Environment Variables
    Should Be True    ${env_loaded}    msg=.env file not loaded! Test cannot proceed without environment configuration.
    Log    Environment variables loaded from .env file successfully    console=True
    Create Directory    ${SCREENSHOT_DIR}
    Log    Test environment initialized successfully

Load Environment Variables
    [Documentation]    Load environment variables from .env file using python-dotenv
    TRY
        ${env_loaded}=    Load Dotenv File
        RETURN    ${env_loaded}
    EXCEPT    AS    ${error}
        Log    FATAL: Failed to load .env file: ${error}    ERROR
        Fail    .env file is required but could not be loaded: ${error}
    END

Take Screenshot On Failure
    [Documentation]    Take screenshot when test fails (only if browser is open)
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${screenshot_name}=    Set Variable    failure_${timestamp}
    
    # Check if browser is open before attempting screenshot
    ${browser_opened}=    Run Keyword And Return Status    Get Browser Catalog
    
    IF    ${browser_opened}
        TRY
            Take Screenshot    ${screenshot_name}
            Log    Screenshot saved: ${screenshot_name}    console=True
        EXCEPT    AS    ${error}
            # Only log if it's an unexpected error (not "no page was open")
            ${is_no_page}=    Run Keyword And Return Status    Should Contain    ${error}    no page was open
            IF    not ${is_no_page}
                Log    Could not take screenshot: ${error}    WARN
            END
        END
    ELSE
        Log    Skipping screenshot - browser not opened    DEBUG
    END

Cleanup Test Environment
    [Documentation]    Clean up test environment and save audit logs
    [Arguments]    ${close_browser}=True
    TRY
        ${audit_file}=    Save Audit Log
        Log    Audit log saved to: ${audit_file}
    EXCEPT
        Log    Could not save audit log    WARN
    END
    
    # Only close browser if explicitly requested
    IF    '${close_browser}' == 'True'
        TRY
            Close Browser    ALL
            Log    Browser closed    console=True
        EXCEPT
            Log    No browser to close    DEBUG
        END
    ELSE
        Log    Browser kept open (close_browser=${close_browser})    console=True
    END
    
    TRY
        Close Session
    EXCEPT
        Log    No session to close    DEBUG
    END

Log Audit Entry
    [Documentation]    Log an audit entry with action, status and details
    [Arguments]    ${action}    ${status}    ${details}=${EMPTY}
    ${details_dict}=    Create Dictionary
    
    ${has_details}=    Run Keyword And Return Status    Should Not Be Equal    ${details}    ${EMPTY}
    IF    ${has_details}
        ${details_dict}=    Evaluate    ${details}
    END
    
    ErrorHandler.Log Audit Entry    ${action}    ${status}    ${details_dict}

Wait And Click Element
    [Documentation]    Wait for element and click with retry logic
    [Arguments]    ${locator}    ${timeout}=${BROWSER_TIMEOUT}
    Wait For Elements State    ${locator}    visible    timeout=${timeout}
    Click    ${locator}
    Log    Clicked element: ${locator}

Wait And Fill Text
    [Documentation]    Wait for element and fill text
    [Arguments]    ${locator}    ${text}    ${timeout}=${BROWSER_TIMEOUT}
    Wait For Elements State    ${locator}    visible    timeout=${timeout}
    Fill Text    ${locator}    ${text}
    Log    Filled text in: ${locator}

Verify Element Contains Text
    [Documentation]    Verify element contains expected text
    [Arguments]    ${locator}    ${expected_text}    ${timeout}=${BROWSER_TIMEOUT}
    Wait For Elements State    ${locator}    visible    timeout=${timeout}
    ${text}=    Get Text    ${locator}
    Should Contain    ${text}    ${expected_text}
    Log    Verified element contains: ${expected_text}

Wait For Page Load
    [Documentation]    Wait for page to fully load
    [Arguments]    ${timeout}=${BROWSER_TIMEOUT}
    Wait For Load State    domcontentloaded    timeout=${timeout}
    Wait For Load State    networkidle    timeout=${timeout}

Safe Click
    [Documentation]    Click element with error handling
    [Arguments]    ${locator}    ${timeout}=${BROWSER_TIMEOUT}
    TRY
        Wait And Click Element    ${locator}    ${timeout}
    EXCEPT    AS    ${error}
        Log    Failed to click element ${locator}: ${error}    WARN
        Take Screenshot    click_failure
        Fail    Could not click element: ${locator}
    END

Safe Fill Text
    [Documentation]    Fill text with error handling
    [Arguments]    ${locator}    ${text}    ${timeout}=${BROWSER_TIMEOUT}
    TRY
        Wait And Fill Text    ${locator}    ${text}    ${timeout}
    EXCEPT    AS    ${error}
        Log    Failed to fill text in ${locator}: ${error}    WARN
        Take Screenshot    fill_failure
        Fail    Could not fill text in element: ${locator}
    END
