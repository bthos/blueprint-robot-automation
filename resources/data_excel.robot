*** Settings ***
Documentation     Excel data handling keywords - reading, writing, and validating Excel files
Library           RPA.Excel.Files
Library           Collections
Library           OperatingSystem
Library           String
Resource          common.robot

*** Variables ***
${EXCEL_FILE_PATH}    %{EXCEL_FILE_PATH=./data/sample_records.xlsx}

*** Keywords ***
Read Excel Data
    [Documentation]    Read data from Excel file and return as list of dictionaries
    [Arguments]    ${file_path}=${EXCEL_FILE_PATH}    ${sheet_name}=Sheet1
    
    File Should Exist    ${file_path}    msg=Excel file not found: ${file_path}
    
    Open Workbook    ${file_path}
    
    ${table}=    Read Worksheet As Table    ${sheet_name}    header=${True}
    
    Close Workbook
    
    # Convert Table object to list of dictionaries
    ${data_list}=    Create List
    FOR    ${row}    IN    @{table}
        Append To List    ${data_list}    ${row}
    END
    
    ${row_count}=    Get Length    ${data_list}
    Log    Read ${row_count} rows from Excel file: ${file_path}
    
    Log Audit Entry    Read Excel Data    SUCCESS    
    ...    {'file': '${file_path}', 'sheet': '${sheet_name}', 'rows': ${row_count}}
    
    RETURN    ${data_list}

Get Excel Column Values
    [Documentation]    Get all values from a specific column
    [Arguments]    ${file_path}    ${sheet_name}    ${column_name}
    
    ${table}=    Read Excel Data    ${file_path}    ${sheet_name}
    
    ${values}=    Create List
    
    FOR    ${row}    IN    @{table}
        ${value}=    Get From Dictionary    ${row}    ${column_name}
        Append To List    ${values}    ${value}
    END
    
    RETURN    ${values}

Write Excel Data
    [Documentation]    Write data to Excel file
    [Arguments]    ${file_path}    ${data}    ${sheet_name}=Results
    
    Create Workbook    ${file_path}
    
    # Create header row from first item keys
    ${first_row}=    Get From List    ${data}    0
    ${headers}=    Get Dictionary Keys    ${first_row}
    
    # Write data
    ${row_number}=    Set Variable    1
    
    FOR    ${row_data}    IN    @{data}
        ${col_number}=    Set Variable    1
        FOR    ${header}    IN    @{headers}
            ${value}=    Get From Dictionary    ${row_data}    ${header}
            Set Cell Value    ${row_number}    ${col_number}    ${value}    ${sheet_name}
            ${col_number}=    Evaluate    ${col_number} + 1
        END
        ${row_number}=    Evaluate    ${row_number} + 1
    END
    
    Save Workbook
    Close Workbook
    
    Log    Wrote ${row_number} rows to Excel file: ${file_path}
    
    Log Audit Entry    Write Excel Data    SUCCESS    
    ...    {'file': '${file_path}', 'sheet': '${sheet_name}', 'rows': ${row_number}}

Write Excel Cell
    [Documentation]    Write a single value to Excel cell by row number and column name
    [Arguments]    ${file_path}    ${row_number}    ${column_name}    ${value}    ${sheet_name}=Sheet1
    
    Open Workbook    ${file_path}
    
    # Read the header to find column index
    ${table}=    Read Worksheet As Table    ${sheet_name}    header=${True}
    
    # Get headers from first row
    ${first_row}=    Get From List    ${table}    0
    ${headers}=    Get Dictionary Keys    ${first_row}
    
    # Find column index (1-based for Excel)
    ${col_index}=    Set Variable    1
    FOR    ${header}    IN    @{headers}
        IF    '${header}' == '${column_name}'
            BREAK
        END
        ${col_index}=    Evaluate    ${col_index} + 1
    END
    
    # Write value (row_number is 1-based, add 1 for header row)
    ${excel_row}=    Evaluate    ${row_number} + 1
    Set Cell Value    ${excel_row}    ${col_index}    ${value}    ${sheet_name}
    
    Save Workbook
    Close Workbook
    
    Log    Wrote '${value}' to row ${row_number}, column '${column_name}'    console=True

Validate Excel Data
    [Documentation]    Validate that required columns exist in Excel data
    [Arguments]    ${data}    @{required_columns}
    
    ${first_row}=    Get From List    ${data}    0
    ${available_columns}=    Get Dictionary Keys    ${first_row}
    
    FOR    ${required_col}    IN    @{required_columns}
        List Should Contain Value    ${available_columns}    ${required_col}
        ...    msg=Required column '${required_col}' not found in Excel data
    END
    
    Log    Excel data validation successful. All required columns present.
    
    Log Audit Entry    Validate Excel Data    SUCCESS    
    ...    {'required_columns': ${required_columns}}

Load Excel Data
    [Documentation]    Load data from Excel file (loads the last row for processing)
    ...    Optionally validates that a specific field is empty (record not yet processed)
    ...    Returns both the record dictionary and the row number
    [Arguments]    ${excel_file_path}    ${processed_field}=${EMPTY}
    
    Log    Loading data from Excel: ${excel_file_path}    console=True
    
    # Use Read Excel Data to read file (returns list of dictionaries)
    ${table}=    Read Excel Data    ${excel_file_path}
    
    # Get the last row as dictionary
    ${row_count}=    Get Length    ${table}
    ${last_row_index}=    Evaluate    ${row_count} - 1
    ${record}=    Get From List    ${table}    ${last_row_index}
    
    # Check if processed field exists and validate it's empty (if specified)
    IF    '${processed_field}' != '${EMPTY}'
        ${has_processed_field}=    Run Keyword And Return Status
        ...    Dictionary Should Contain Key    ${record}    ${processed_field}
        
        IF    ${has_processed_field}
            ${processed_value}=    Get From Dictionary    ${record}    ${processed_field}
            ${processed_str}=    Convert To String    ${processed_value}
            ${processed_trimmed}=    Strip String    ${processed_str}
            
            # Check if processed field has a valid value (not empty, not None, not 'nan')
            ${is_empty}=    Run Keyword And Return Status
            ...    Should Be Empty    ${processed_trimmed}
            
            ${is_none}=    Run Keyword And Return Status
            ...    Should Be Equal As Strings    ${processed_trimmed}    None    ignore_case=True
            
            ${is_nan}=    Run Keyword And Return Status
            ...    Should Be Equal As Strings    ${processed_trimmed}    nan    ignore_case=True
            
            # If processed field is NOT empty/None/nan, record already processed
            IF    not ${is_empty} and not ${is_none} and not ${is_nan}
                Log    ${processed_field} is already set (${processed_trimmed}) - record already processed    console=True
                Log Audit Entry    Load Excel Data    FAILURE    {'error': 'Record already processed', '${processed_field}': '${processed_trimmed}'}
                Fail    Record already processed (row ${row_count}). ${processed_field}: ${processed_trimmed}
            ELSE
                Log    ${processed_field} is empty - proceeding with processing    console=True
            END
        ELSE
            Log    ${processed_field} column doesn't exist - proceeding    console=True
        END
    END
    
    Log    Excel data loaded successfully (row ${row_count} of ${row_count})    console=True
    Log Audit Entry    Load Excel Data    SUCCESS    {'file': '${excel_file_path}', 'row': ${row_count}}
    
    # Return both the record and the row number (for writing back to Excel)
    RETURN    ${record}    ${row_count}

Filter Excel Data
    [Documentation]    Filter Excel data based on a condition
    [Arguments]    ${data}    ${column_name}    ${filter_value}
    
    ${filtered_data}=    Create List
    
    FOR    ${row}    IN    @{data}
        ${value}=    Get From Dictionary    ${row}    ${column_name}
        IF    '${value}' == '${filter_value}'
            Append To List    ${filtered_data}    ${row}
        END
    END
    
    ${count}=    Get Length    ${filtered_data}
    Log    Filtered data: ${count} rows match criteria
    
    RETURN    ${filtered_data}

Get Row By Field Value
    [Documentation]    Get a specific row where a field matches a value
    [Arguments]    ${data}    ${field_name}    ${field_value}
    
    FOR    ${row}    IN    @{data}
        ${value}=    Get From Dictionary    ${row}    ${field_name}
        IF    '${value}' == '${field_value}'
            RETURN    ${row}
        END
    END
    
    Log    No row found with ${field_name}=${field_value}    WARN
    RETURN    ${EMPTY}
