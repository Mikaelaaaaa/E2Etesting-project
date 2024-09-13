*** Settings ***
Documentation    資料集列表頁
Resource    ${CURDIR}/../resouces/PageDataSets.resource
Resource    ${CURDIR}/../resouces/general.resource
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary
Suite Teardown   SeleniumLibrary.Close Browser
Test Teardown    Take Screenshot if Failed

*** Variables ***
${datasetname}    


*** Keywords ***
Login to Page PUZZLE
    [Documentation]    準備systalk的測試環境
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


*** Test Cases ***
DA001 Open the window of adding new dataset
    [Documentation]    This test case verifies the opening of the window of adding new dataset.
    [Tags]    Regression
    Open adding new dataset window

DA043 Default of adding button is disable
    [Documentation]    This test case verifies the default of adding button in the adding new dataset window should be disable when opens the window.
    [Tags]    Regression
    Open adding new dataset window
    Sleep    3
    Locate to the disable adding new button

DA002 Choose different dataset types
    [Documentation]    This test case verifies that dataset type can be chosen.
    [Tags]    Regression
    Open adding new dataset window
    Sleep    3
    Open the dropdown of dataset types
    Choose dataset type    分類資料集
    Sleep    3
    Verify dropdown list result    分類資料集
    Open the dropdown of dataset types
    Choose dataset type    實體資料集
    Sleep    3
    Verify dropdown list result    實體資料集
    Open the dropdown of dataset types
    Choose dataset type    OCR資料集
    Sleep    3
    Verify dropdown list result    OCR資料集

DA003 The rule of input dataset's name - cannot be empty
    [Documentation]    This test case verifies that the input area of a name for adding a new dataset should not be empty.
    [Tags]    Regression
    Open adding new dataset window
    Sleep     3





