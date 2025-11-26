*** Settings ***
Documentation     Helper keywords and template builders
...               CUSTOMIZE: Update templates for your application's needs
Library           Collections
Library           String
Library           DateTime
Resource          common.robot

*** Keywords ***
Build Description From Template
    [Documentation]    Build a description string from template and data
    ...    CUSTOMIZE: Update template format for your application
    [Arguments]    ${record}    ${template}
    
    # Get values from record with safe defaults
    ${name}=    Get From Dictionary    ${record}    Name    default=Unknown
    ${type}=    Get From Dictionary    ${record}    Type    default=Standard
    ${env}=    Get From Dictionary    ${record}    Environment    default=DEV
    
    # Replace placeholders in template
    ${result}=    Replace String    ${template}    {name}    ${name}
    ${result}=    Replace String    ${result}    {type}    ${type}
    ${result}=    Replace String    ${result}    {environment}    ${env}
    
    RETURN    ${result}

Build Short Description
    [Documentation]    Build short description from record data
    ...    CUSTOMIZE: Update format for your application
    [Arguments]    ${record}
    
    # Example template - customize for your needs
    ${name}=    Get From Dictionary    ${record}    Name    default=Item
    ${type}=    Get From Dictionary    ${record}    Type    default=Standard
    ${env}=    Get From Dictionary    ${record}    Environment    default=DEV
    
    ${short_desc}=    Set Variable    ${name} - ${type} (${env})
    
    Log    Built short description: ${short_desc}    console=True
    RETURN    ${short_desc}

Build Implementation Plan
    [Documentation]    Build implementation plan based on environment
    ...    CUSTOMIZE: Update plan templates for your process
    [Arguments]    ${record}
    
    ${env}=    Get From Dictionary    ${record}    Environment    default=DEV
    
    ${plan}=    Set Variable    Implementation will be deployed to ${env} environment.
    
    IF    '${env}' == 'PROD'
        ${plan}=    Set Variable    ${plan}\nProduction deployment requires approval.
    END
    
    RETURN    ${plan}

Build Test Plan
    [Documentation]    Build test plan with conditional sections
    ...    CUSTOMIZE: Update test plan logic for your process
    [Arguments]    ${record}
    
    ${env}=    Get From Dictionary    ${record}    Environment    default=DEV
    ${type}=    Get From Dictionary    ${record}    Type    default=Standard
    ${regression_required}=    Get From Dictionary    ${record}    Regression Required    default=No
    
    # Start with base test plan
    ${plan_lines}=    Create List
    Append To List    ${plan_lines}    1. Visual verification after deployment.
    
    # Add environment-specific steps
    IF    '${env}' == 'PROD'
        Append To List    ${plan_lines}    2. Production smoke tests will be executed.
        Append To List    ${plan_lines}    3. Business validation testing required.
    ELSE
        Append To List    ${plan_lines}    2. Standard smoke tests will be executed.
    END
    
    # Add regression if required
    IF    '${regression_required}' == 'Yes'
        Append To List    ${plan_lines}    4. Regression testing will be performed.
    END
    
    ${plan}=    Catenate    SEPARATOR=\n    @{plan_lines}
    
    RETURN    ${plan}

Build Backout Plan
    [Documentation]    Build backout/rollback plan
    [Arguments]    ${record}
    
    ${env}=    Get From Dictionary    ${record}    Environment    default=DEV
    
    ${plan}=    Set Variable    In case of issues, rollback to previous version and notify stakeholders.
    
    IF    '${env}' == 'PROD'
        ${plan}=    Set Variable    ${plan}\nProduction rollback requires change management approval.
    END
    
    RETURN    ${plan}

Format Date For Application
    [Documentation]    Format date for application input
    ...    CUSTOMIZE: Update date format for your application
    [Arguments]    ${date}    ${input_format}=%Y-%m-%d    ${output_format}=%d/%m/%Y
    
    ${formatted}=    Convert Date    ${date}    result_format=${output_format}    date_format=${input_format}
    
    RETURN    ${formatted}

Calculate Future Date
    [Documentation]    Calculate a date in the future
    [Arguments]    ${days}=1    ${from_date}=${EMPTY}
    
    ${base_date}=    Set Variable If    '${from_date}' != '${EMPTY}'    ${from_date}    ${EMPTY}
    
    IF    '${base_date}' == '${EMPTY}'
        ${base_date}=    Get Current Date    result_format=%Y-%m-%d
    END
    
    ${future_date}=    Add Time To Date    ${base_date}    ${days} days    result_format=%Y-%m-%d
    
    RETURN    ${future_date}

Generate Unique ID
    [Documentation]    Generate a unique identifier for tracking
    [Arguments]    ${prefix}=AUTO
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${unique_id}=    Set Variable    ${prefix}_${timestamp}
    
    RETURN    ${unique_id}

Safe Get Dictionary Value
    [Documentation]    Safely get value from dictionary with default
    [Arguments]    ${dict}    ${key}    ${default}=${EMPTY}
    
    ${has_key}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${dict}    ${key}
    
    IF    ${has_key}
        ${value}=    Get From Dictionary    ${dict}    ${key}
        ${value_str}=    Convert To String    ${value}
        ${value_trimmed}=    Strip String    ${value_str}
        
        # Check for None or nan
        ${is_none}=    Run Keyword And Return Status
        ...    Should Be Equal As Strings    ${value_trimmed}    None    ignore_case=True
        
        ${is_nan}=    Run Keyword And Return Status
        ...    Should Be Equal As Strings    ${value_trimmed}    nan    ignore_case=True
        
        IF    ${is_none} or ${is_nan}
            RETURN    ${default}
        END
        
        RETURN    ${value_trimmed}
    ELSE
        RETURN    ${default}
    END

Log Record Summary
    [Documentation]    Log a summary of record data for debugging
    [Arguments]    ${record}    ${fields_to_log}=${EMPTY}
    
    Log    ===== Record Summary =====    console=True
    
    ${keys}=    Get Dictionary Keys    ${record}
    
    IF    '${fields_to_log}' != '${EMPTY}'
        ${keys}=    Set Variable    ${fields_to_log}
    END
    
    FOR    ${key}    IN    @{keys}
        ${value}=    Safe Get Dictionary Value    ${record}    ${key}    N/A
        Log    ${key}: ${value}    console=True
    END
    
    Log    ==========================    console=True
