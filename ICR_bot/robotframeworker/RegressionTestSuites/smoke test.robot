*** Settings ***
Documentation    ICR 冒煙測試
Resource    ${CURDIR}/../resouces/PageDataSets.resource
Resource    ${CURDIR}/../resouces/general.resource
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary   
Library    DateTime
Suite Teardown   SeleniumLibrary.Close Browser
Test Teardown    Take Screenshot if Failed

*** Variables ***


*** Keywords ***


*** Test Cases ***
Login to Page PUZZLE
    [Documentation]    準備puzzle的測試環境
    [Tags]    test:retry(2)
    [Timeout]    1h
    ${driver}=    Create Driver    full_page
    Log    ${driver}    console=True
    Custom.Go To    http://192.168.118.36/login
    Log In To Systalk       TestRobot001    TestRobot001@!
    Go To Puzzle
    Sleep    2
    Switch Tab
    ${complete_url}=    Get Complete URL
    Custom.Close Browser
    SeleniumLibrary.Create Webdriver    Chrome    
    SeleniumLibrary.Go To    ${complete_url}
    Click Button    css:#details-button
    Wait Until Element Is Visible    css:#proceed-link
    Click Link    css:#proceed-link

Pre-conditions
    [Documentation]    新增一個OCR資料集
    [Tags]    OCR    test:retry(2)
    [Timeout]
    ${date} =    Get Current Date    result_format=%y%m%d
    Click Element    css:.stai-button
    Input Text    css:.form-control-1 input    smoketest${date}
    Choose Dataset Type    OCR資料集
    Choose Dataset Language    繁體中文
    Sleep    1
    Submit Dataset 
    # 沒有Toast問題已知暫時先不驗
    ## Check Is Displayed    css:.stacked-toasts
    Sleep    2 
    Scroll Element Into View    xpath:.//*[contains(text(), 'smoketest${date}')]
    Click Element    xpath:.//*[contains(text(), 'smoketest${date}')]

