*** Settings ***
Documentation     SSO Authentication keywords for federated login
...               Customize selectors and flow for your SSO provider
Library           Browser
Resource          common.robot

*** Variables ***
# SSO Page Selectors - CUSTOMIZE THESE for your SSO provider
${SSO_USERNAME_FIELD}     input[type="email"], input[name="username"], #username
${SSO_PASSWORD_FIELD}     input[type="password"], input[name="password"], #password
${SSO_SUBMIT_BUTTON}      button[type="submit"], input[type="submit"], #submit

# MFA Selectors - CUSTOMIZE THESE if your SSO uses MFA
${MFA_INPUT_FIELD}        input[name="code"], input[id="mfa-code"]
${MFA_PROMPT_SELECTOR}    text=Verify, text=Authentication, text=MFA

*** Keywords ***
Complete SSO Login
    [Documentation]    Complete the SSO login flow
    ...    Customize this keyword for your specific SSO provider
    [Arguments]    ${expected_url_fragment}    ${step}=01    ${max_wait_time}=300
    
    ${sso_username}=    Get Environment Variable    SSO_USERNAME
    ${sso_password}=    Get Environment Variable    SSO_PASSWORD
    
    # Validate credentials are not empty
    ${username_trimmed}=    Strip String    ${sso_username}
    ${password_trimmed}=    Strip String    ${sso_password}
    
    IF    '${username_trimmed}' == '${EMPTY}'
        Fail    SSO_USERNAME environment variable is empty. Please set it in .env file.
    END
    
    IF    '${password_trimmed}' == '${EMPTY}'
        Fail    SSO_PASSWORD environment variable is empty. Please set it in .env file.
    END
    
    # Wait for SSO page to load
    Sleep    2s
    Take Screenshot    step${step}_01_sso_page
    
    # Get current URL to detect which SSO provider we're on
    ${current_url}=    Get Url
    Log    Current SSO URL: ${current_url}    console=True
    
    # Try to fill username field
    ${username_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${SSO_USERNAME_FIELD}    visible    timeout=10s
    
    IF    ${username_found}
        Log    Found username field, entering credentials    console=True
        Fill Text    ${SSO_USERNAME_FIELD}    ${sso_username}
        Take Screenshot    step${step}_02_username_entered
        
        # Some SSO providers have separate username/password pages
        # Try to click Next/Continue if present
        ${has_next_button}=    Run Keyword And Return Status
        ...    Wait For Elements State    text=Next, text=Continue    visible    timeout=3s
        
        IF    ${has_next_button}
            Click    text=Next, text=Continue
            Sleep    2s
        END
        
        # Enter password
        ${password_found}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${SSO_PASSWORD_FIELD}    visible    timeout=10s
        
        IF    ${password_found}
            Fill Text    ${SSO_PASSWORD_FIELD}    ${sso_password}
            Take Screenshot    step${step}_03_password_entered
            
            # Submit the form
            Keyboard Key    press    Enter
            Log    Submitted login form    console=True
        END
    ELSE
        Log    Username field not found - SSO might use different selectors    WARN
        Take Screenshot    step${step}_02_sso_no_username_field
    END
    
    # Wait for login to complete or MFA prompt
    Sleep    3s
    Take Screenshot    step${step}_04_after_submit
    
    # Check for MFA prompt and wait for user if needed
    ${mfa_required}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${MFA_PROMPT_SELECTOR}    visible    timeout=5s
    
    IF    ${mfa_required}
        Log    MFA authentication detected - waiting for user input    console=True
        Log    ========================================    console=True
        Log    WAITING FOR MFA AUTHENTICATION    console=True
        Log    Please complete MFA on your device    console=True
        Log    Timeout: ${max_wait_time} seconds    console=True
        Log    ========================================    console=True
        
        Take Screenshot    step${step}_05_mfa_prompt
        
        # Wait for MFA to complete (URL should change to expected destination)
        Wait For MFA Completion    ${expected_url_fragment}    ${max_wait_time}
    END
    
    # Verify login was successful
    ${final_url}=    Get Url
    Log    Final URL after login: ${final_url}    console=True
    
    ${login_success}=    Run Keyword And Return Status
    ...    Should Contain    ${final_url}    ${expected_url_fragment}
    
    IF    ${login_success}
        Log    SSO login completed successfully    console=True
        Take Screenshot    step${step}_06_login_success
    ELSE
        Take Screenshot    step${step}_06_login_unexpected_page
        Log    Warning: URL does not contain expected fragment: ${expected_url_fragment}    WARN
    END

Wait For MFA Completion
    [Documentation]    Wait for MFA authentication to complete
    [Arguments]    ${expected_url_fragment}    ${max_wait_time}=300
    
    ${wait_interval}=    Set Variable    5
    ${total_waited}=    Set Variable    0
    
    WHILE    ${total_waited} < ${max_wait_time}
        Sleep    ${wait_interval}s
        ${total_waited}=    Evaluate    ${total_waited} + ${wait_interval}
        
        ${current_url}=    Get Url
        ${mfa_complete}=    Run Keyword And Return Status
        ...    Should Contain    ${current_url}    ${expected_url_fragment}
        
        IF    ${mfa_complete}
            Log    MFA completed after ${total_waited} seconds    console=True
            RETURN
        END
        
        Log    Waiting for MFA... (${total_waited}/${max_wait_time}s)    console=True
    END
    
    # If we get here, MFA timed out
    ${final_url}=    Get Url
    Log    MFA timeout - current URL: ${final_url}    WARN
    Fail    MFA authentication timed out after ${max_wait_time} seconds

Fill SSO Credentials
    [Documentation]    Fill SSO username and password fields
    [Arguments]    ${username}    ${password}
    
    Wait And Fill Text    ${SSO_USERNAME_FIELD}    ${username}
    Wait And Fill Text    ${SSO_PASSWORD_FIELD}    ${password}
    Take Screenshot    sso_credentials_entered
    
Submit SSO Form
    [Documentation]    Submit the SSO login form
    
    ${submit_found}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${SSO_SUBMIT_BUTTON}    visible    timeout=5s
    
    IF    ${submit_found}
        Click    ${SSO_SUBMIT_BUTTON}
    ELSE
        # Fallback to pressing Enter
        Keyboard Key    press    Enter
    END
    
    Log    SSO form submitted    console=True
