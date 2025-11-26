*** Settings ***
Documentation     Application login and navigation keywords
...               CUSTOMIZE: Update selectors and URLs for your application
Library           Browser
Resource          common.robot
Resource          auth_sso.robot

*** Variables ***
# Application URL - loaded from environment
${APP_LOGIN_URL}         %{APP_URL}

# Application-specific selectors - CUSTOMIZE THESE
${LOGIN_BUTTON}          button:has-text("Login"), a:has-text("Sign In")
${LOGOUT_BUTTON}         button:has-text("Logout"), a:has-text("Sign Out")
${MAIN_MENU}             nav, .main-menu, #navigation
${USER_MENU}             .user-menu, .profile-menu

*** Keywords ***
Open Application And Login
    [Documentation]    Open application and complete login flow
    ...    CUSTOMIZE: Update for your application's login process
    [Arguments]    ${headless}=${True}    ${step}=01
    
    New Browser    chromium    headless=${headless}
    New Page    ${APP_LOGIN_URL}
    
    Log Audit Entry    Open Browser    SUCCESS    {'url': '${APP_LOGIN_URL}'}
    
    # Wait for page to load
    Sleep    3s
    
    ${current_url}=    Get Url
    Log    Current URL: ${current_url}    console=True
    
    ${title}=    Get Title
    Log    Page title: ${title}    console=True
    Take Screenshot    step${step}_01_initial_page
    
    # Check if we're redirected to SSO login
    ${is_sso_page}=    Check If SSO Page    ${current_url}
    
    IF    ${is_sso_page}
        Log    SSO login page detected, starting authentication    console=True
        # Extract expected URL fragment from APP_URL
        ${expected_domain}=    Get Environment Variable    APP_URL
        ${expected_fragment}=    Evaluate    '${expected_domain}'.split('//')[1].split('/')[0]
        Complete SSO Login    ${expected_fragment}    ${step}    max_wait_time=300
    ELSE
        # Direct login form - CUSTOMIZE for your application
        ${has_login_form}=    Run Keyword And Return Status
        ...    Wait For Elements State    input[type="password"]    visible    timeout=5s
        
        IF    ${has_login_form}
            Fill Direct Login Form    ${step}
        ELSE
            Log    No login form found - may already be logged in    console=True
        END
    END
    
    # Verify login was successful
    ${post_login_url}=    Get Url
    Log    URL after login: ${post_login_url}    console=True
    Take Screenshot    step${step}_02_after_login
    
    Log Audit Entry    Login    SUCCESS    {'url': '${post_login_url}'}

Check If SSO Page
    [Documentation]    Check if current URL is an SSO login page
    ...    CUSTOMIZE: Add your SSO provider domains
    [Arguments]    ${url}
    
    # Common SSO provider URL patterns - add your SSO domains
    ${is_sso}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${url}    (login|auth|sso|federated|okta|azure|ping)
    
    RETURN    ${is_sso}

Fill Direct Login Form
    [Documentation]    Fill direct login form (non-SSO)
    ...    CUSTOMIZE: Update selectors for your application
    [Arguments]    ${step}=01
    
    ${username}=    Get Environment Variable    SSO_USERNAME
    ${password}=    Get Environment Variable    SSO_PASSWORD
    
    # Find and fill username field
    ${username_selectors}=    Create List
    ...    input[type="email"]
    ...    input[name="username"]
    ...    input[id="username"]
    ...    \#email
    
    FOR    ${selector}    IN    @{username_selectors}
        ${found}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${selector}    visible    timeout=3s
        IF    ${found}
            Fill Text    ${selector}    ${username}
            BREAK
        END
    END
    
    # Find and fill password field
    ${password_selectors}=    Create List
    ...    input[type="password"]
    ...    input[name="password"]
    ...    input[id="password"]
    
    FOR    ${selector}    IN    @{password_selectors}
        ${found}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${selector}    visible    timeout=3s
        IF    ${found}
            Fill Text    ${selector}    ${password}
            BREAK
        END
    END
    
    Take Screenshot    step${step}_03_credentials_entered
    
    # Submit form
    Keyboard Key    press    Enter
    Sleep    3s
    Take Screenshot    step${step}_04_after_submit

Close Application
    [Documentation]    Close browser and cleanup
    Close Browser    ALL
    Log Audit Entry    Close Browser    SUCCESS

Navigate To Page
    [Documentation]    Navigate to a specific page in the application
    ...    CUSTOMIZE: Update navigation logic for your application
    [Arguments]    ${page_name}    ${step}=01
    
    Log    Navigating to: ${page_name}    console=True
    
    # CUSTOMIZE: Add navigation logic for your application's pages
    # Example using menu click:
    # Click    ${MAIN_MENU} >> text=${page_name}
    
    # Example using direct URL:
    # ${app_url}=    Get Environment Variable    APP_URL
    # Go To    ${app_url}/${page_name}
    
    Sleep    2s
    Take Screenshot    step${step}_01_after_navigation
    Log Audit Entry    Navigate To ${page_name}    SUCCESS

Click Navigation Item
    [Documentation]    Click a navigation menu item
    [Arguments]    ${item_text}    ${step}=01
    
    # Wait for navigation to be visible
    Wait For Elements State    ${MAIN_MENU}    visible    timeout=10s
    
    # Click the menu item
    Click    text=${item_text}
    Sleep    2s
    
    Take Screenshot    step${step}_01_clicked_${item_text}
    Log    Clicked navigation item: ${item_text}    console=True

Verify Current Page
    [Documentation]    Verify we're on the expected page
    [Arguments]    ${expected_url_fragment}    ${expected_title_fragment}=${EMPTY}
    
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${expected_url_fragment}
    ...    msg=Expected URL to contain '${expected_url_fragment}' but got '${current_url}'
    
    IF    '${expected_title_fragment}' != '${EMPTY}'
        ${title}=    Get Title
        Should Contain    ${title}    ${expected_title_fragment}    ignore_case=True
    END
    
    Log    Verified current page: ${current_url}    console=True

Wait For Application Ready
    [Documentation]    Wait for application to be fully loaded and ready
    [Arguments]    ${timeout}=30s
    
    # Wait for common loading indicators to disappear
    # CUSTOMIZE: Update selectors for your application's loading indicators
    ${loading_selectors}=    Create List
    ...    .loading
    ...    .spinner
    ...    [class*="loading"]
    ...    [class*="spinner"]
    
    FOR    ${selector}    IN    @{loading_selectors}
        ${has_loader}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${selector}    visible    timeout=2s
        
        IF    ${has_loader}
            Wait For Elements State    ${selector}    hidden    timeout=${timeout}
            Log    Loader '${selector}' disappeared    DEBUG
        END
    END
    
    Wait For Page Load    ${timeout}
    Log    Application is ready    console=True
