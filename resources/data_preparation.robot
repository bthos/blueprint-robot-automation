*** Settings ***
Documentation     Data preparation - unified interface for loading data from Excel or SharePoint
Library           Collections
Resource          common.robot
Resource          data_excel.robot

*** Variables ***
${DATA_SOURCE}    %{DATA_SOURCE=excel}

*** Keywords ***
Load Deployment Data
    [Documentation]    Load data from configured source (Excel or SharePoint)
    ...    Returns: record dictionary, identifier (row number or SharePoint item ID), source name
    [Arguments]    ${source}=${DATA_SOURCE}    ${file_path}=${EMPTY}
    
    Log    Loading data from source: ${source}    console=True
    
    IF    '${source}' == 'excel'
        ${excel_file}=    Set Variable If    '${file_path}' != '${EMPTY}'    ${file_path}    %{EXCEL_FILE_PATH=./data/sample_records.xlsx}
        ${record}    ${row_number}=    Load Excel Data    ${excel_file}
        RETURN    ${record}    ${row_number}    excel
    ELSE IF    '${source}' == 'sharepoint'
        # SharePoint loading - requires data_sharepoint.robot to be implemented
        ${record}    ${item_id}=    Load SharePoint Data
        RETURN    ${record}    ${item_id}    sharepoint
    ELSE
        Fail    Unknown data source: ${source}. Supported sources: excel, sharepoint
    END

Write Result To Data Source
    [Documentation]    Write result back to data source
    ...    For Excel: writes to specified cell
    ...    For SharePoint: updates item field
    [Arguments]    ${source}    ${identifier}    ${field_name}    ${value}    ${file_path}=${EMPTY}
    
    IF    '${source}' == 'excel'
        ${excel_file}=    Set Variable If    '${file_path}' != '${EMPTY}'    ${file_path}    %{EXCEL_FILE_PATH=./data/sample_records.xlsx}
        Write Excel Cell    ${excel_file}    ${identifier}    ${field_name}    ${value}
        Log    Wrote ${value} to Excel row ${identifier}, column ${field_name}    console=True
    ELSE IF    '${source}' == 'sharepoint'
        # SharePoint update - requires data_sharepoint.robot to be implemented
        Update SharePoint Item    ${identifier}    ${field_name}    ${value}
        Log    Updated SharePoint item ${identifier}, field ${field_name}    console=True
    ELSE
        Log    Unknown data source: ${source}    WARN
    END

Cleanup Data Source
    [Documentation]    Cleanup/disconnect from data source
    [Arguments]    ${source}
    
    IF    '${source}' == 'sharepoint'
        # Disconnect from SharePoint if needed
        TRY
            Disconnect From SharePoint
        EXCEPT
            Log    SharePoint was not connected    DEBUG
        END
    ELSE
        Log    No cleanup needed for ${source}    DEBUG
    END

Validate Record Data
    [Documentation]    Validate that record contains required fields
    [Arguments]    ${record}    @{required_fields}
    
    FOR    ${field}    IN    @{required_fields}
        ${has_field}=    Run Keyword And Return Status
        ...    Dictionary Should Contain Key    ${record}    ${field}
        
        IF    not ${has_field}
            Fail    Record missing required field: ${field}
        END
        
        ${value}=    Get From Dictionary    ${record}    ${field}
        ${value_str}=    Convert To String    ${value}
        ${is_empty}=    Run Keyword And Return Status
        ...    Should Be Empty    ${value_str}
        
        IF    ${is_empty}
            Log    Warning: Required field '${field}' is empty    WARN
        END
    END
    
    Log    Record validation passed for ${required_fields}    console=True

Get Record Field
    [Documentation]    Safely get a field from record with default value
    [Arguments]    ${record}    ${field_name}    ${default}=${EMPTY}
    
    ${has_field}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${record}    ${field_name}
    
    IF    ${has_field}
        ${value}=    Get From Dictionary    ${record}    ${field_name}
        ${value_str}=    Convert To String    ${value}
        ${value_trimmed}=    Strip String    ${value_str}
        
        # Check for None or nan values
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
