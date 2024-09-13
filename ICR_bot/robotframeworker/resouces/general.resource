
*** Settings ***
Documentation     Keywords for all test cases.           
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary

*** Variables ***


*** Keywords *** 
Check Is Displayed
    [Arguments]    ${selector}
    ${is_displayed}=    Is Displayed    ${selector}
    Should Be Equal    ${is_displayed}    ${True}

Check To Be Empty
    [Arguments]    ${selector}
    ${is_empty}=    Is Empty    ${selector}
    Should Be Equal    ${is_empty}    ${True}

Take Screenshot IF Failed
    [Setup]    Set Screenshot Directory    EMBED
    Run Keyword If Test Failed  Capture Page Screenshot



# Skip Execution if Test Failed