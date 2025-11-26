*** Settings ***
Documentation     Sample form filling keywords
...               CUSTOMIZE: Create form_*.robot files for each section of your application's forms
Library           Browser
Resource          common.robot
Resource          helpers.robot

*** Variables ***
# Form field selectors - CUSTOMIZE THESE for your application
${FORM_NAME_FIELD}           input[name="name"], #name
${FORM_DESCRIPTION_FIELD}    textarea[name="description"], #description
${FORM_TYPE_DROPDOWN}        select[name="type"], #type
${FORM_PRIORITY_DROPDOWN}    select[name="priority"], #priority
${FORM_DATE_FIELD}           input[type="date"], input[name="date"]
${FORM_SUBMIT_BUTTON}        button[type="submit"], input[type="submit"]

*** Keywords ***
Fill Basic Form Details
    [Documentation]    Fill basic form details from record data
    ...    CUSTOMIZE: Update for your application's form fields
    [Arguments]    ${record}    ${step}=01
    
    Log    Filling basic form details    console=True
    Take Screenshot    step${step}_01_before_filling
    
    # Get values from record
    ${name}=    Safe Get Dictionary Value    ${record}    Name    Item Name
    ${description}=    Safe Get Dictionary Value    ${record}    Description    ${EMPTY}
    ${type}=    Safe Get Dictionary Value    ${record}    Type    Standard
    
    # Fill Name field
    ${name_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${FORM_NAME_FIELD}    visible    timeout=10s
    
    IF    ${name_found}
        Fill Text    ${FORM_NAME_FIELD}    ${name}
        Log    Filled name: ${name}    console=True
    ELSE
        Log    Name field not found with selector: ${FORM_NAME_FIELD}    WARN
    END
    
    # Fill Description field
    ${desc_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${FORM_DESCRIPTION_FIELD}    visible    timeout=5s
    
    IF    ${desc_found}
        Fill Text    ${FORM_DESCRIPTION_FIELD}    ${description}
        Log    Filled description    console=True
    END
    
    Take Screenshot    step${step}_02_after_filling_basic
    Log Audit Entry    Fill Basic Form Details    SUCCESS

Fill Dropdown Field
    [Documentation]    Fill a dropdown/select field
    [Arguments]    ${selector}    ${value}    ${use_keyboard}=${False}
    
    ${dropdown_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${selector}    visible    timeout=10s
    
    IF    not ${dropdown_found}
        Fail    Dropdown not found: ${selector}
    END
    
    IF    ${use_keyboard}
        # Some applications need focus + type approach
        Click    ${selector}
        # Wait for dropdown options to appear
        Wait For Elements State    ${selector}    stable    timeout=5s
        Keyboard Input    type    ${value}
        Keyboard Key    press    Enter
    ELSE
        # Standard select approach
        Select Options By    ${selector}    text    ${value}
    END
    
    Log    Selected '${value}' in dropdown ${selector}    console=True

Fill Date Field
    [Documentation]    Fill a date field with proper formatting
    [Arguments]    ${selector}    ${date_value}    ${format}=%Y-%m-%d
    
    Wait For Elements State    ${selector}    visible    timeout=10s
    
    # Format date if needed
    ${formatted_date}=    Convert Date    ${date_value}    result_format=${format}
    
    Fill Text    ${selector}    ${formatted_date}
    Log    Filled date: ${formatted_date}    console=True

Fill Priority Field
    [Documentation]    Fill priority dropdown
    [Arguments]    ${priority}=Normal    ${step}=01
    
    Log    Setting priority to: ${priority}    console=True
    
    Fill Dropdown Field    ${FORM_PRIORITY_DROPDOWN}    ${priority}
    
    Take Screenshot    step${step}_priority_set
    Log Audit Entry    Set Priority    SUCCESS    {'priority': '${priority}'}

Fill All Form Fields
    [Documentation]    Fill all form fields from record data
    ...    CUSTOMIZE: Update field mappings for your application
    [Arguments]    ${record}    ${step}=01
    
    Log    ===== Filling all form fields =====    console=True
    Log Record Summary    ${record}
    
    # Fill each section
    Fill Basic Form Details    ${record}    ${step}
    
    # Add more section calls as needed
    # Fill Extended Details    ${record}    ${step}
    # Fill Configuration Options    ${record}    ${step}
    
    Take Screenshot    step${step}_99_all_fields_filled
    Log    All form fields filled    console=True

Submit Form
    [Documentation]    Submit the form
    [Arguments]    ${step}=01
    
    Take Screenshot    step${step}_01_before_submit
    
    ${submit_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${FORM_SUBMIT_BUTTON}    visible    timeout=10s
    
    IF    ${submit_found}
        Click    ${FORM_SUBMIT_BUTTON}
        Log    Clicked submit button    console=True
    ELSE
        Log    Submit button not found, trying Enter key    WARN
        Keyboard Key    press    Enter
    END
    
    Sleep    3s
    Take Screenshot    step${step}_02_after_submit
    Log Audit Entry    Submit Form    SUCCESS

Verify Form Submission
    [Documentation]    Verify form was submitted successfully
    ...    CUSTOMIZE: Update success indicators for your application
    [Arguments]    ${step}=01
    
    # Check for success message
    ${success_selectors}=    Create List
    ...    text=Success
    ...    text=Created
    ...    text=Submitted
    ...    .success-message
    ...    .alert-success
    
    ${success_found}=    Set Variable    ${False}
    
    FOR    ${selector}    IN    @{success_selectors}
        ${found}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${selector}    visible    timeout=5s
        
        IF    ${found}
            ${success_found}=    Set Variable    ${True}
            Log    Success indicator found: ${selector}    console=True
            BREAK
        END
    END
    
    Take Screenshot    step${step}_verification
    
    IF    not ${success_found}
        Log    No success indicator found - check submission manually    WARN
    END
    
    RETURN    ${success_found}

Get Created Record ID
    [Documentation]    Extract the created record ID from the page
    ...    CUSTOMIZE: Update selectors/patterns for your application
    [Arguments]    ${step}=01
    
    # Common patterns for record IDs
    # CUSTOMIZE: Update these patterns for your application
    ${id_patterns}=    Create List
    ...    .*ID[:\\s]*(\\w+).*
    ...    .*Record[:\\s]*(\\d+).*
    ...    .*#(\\d+).*
    
    ${page_text}=    Get Text    body
    
    FOR    ${pattern}    IN    @{id_patterns}
        ${matches}=    Get Regexp Matches    ${page_text}    ${pattern}    1
        ${count}=    Get Length    ${matches}
        
        IF    ${count} > 0
            ${record_id}=    Get From List    ${matches}    0
            Log    Found record ID: ${record_id}    console=True
            RETURN    ${record_id}
        END
    END
    
    Log    Could not extract record ID from page    WARN
    RETURN    ${EMPTY}
