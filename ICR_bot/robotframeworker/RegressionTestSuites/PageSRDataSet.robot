*** Settings ***
Documentation    SR標註類別相關測試案例
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

Open Label Category List  # 標註類別列表
    Click Element    xpath:.//*[@id="mat-tab-content-0-0"]/div/puzzle-sr-details/puzzle-side-menu/div/div/div[3]/img
Open Label Creation Popup  # 新增標註類別彈窗
    Click Element    css:.add-btn

*** Test Cases ***
Setup For Test
    [Documentation]    準備systalk的測試環境
    [Tags]    test:retry(2)
    [Timeout]
    Login to Page PUZZLE     
    Sleep    2    

Pre-conditions
    [Documentation]    先建立一份新的SR資料集，並進入內頁
    [Tags]    test:retry(2)
    [Timeout]
    ${datasetname}=     Custom.Random   5
    Click Element    css:.stai-button
    Input Text    css:.form-control-1 input    ${datasetname}
    Choose Dataset Type    SR資料集
    Submit Dataset 
    # 沒有Toast問題已知暫時先不驗
    ## Check Is Displayed    css:.stacked-toasts
    Sleep    2 
    Scroll Element Into View    xpath:.//*[contains(text(), '${datasetname}')]
    Click Element    xpath:.//*[contains(text(), '${datasetname}')] 

SAA006
    [Documentation]    驗證標註類別名稱只能輸入2-15字，輸入16字名稱(測試案例編碼待改動)
    [Tags]    sidebar    Regression
    [Timeout]
    Open Label Category List
    Open Label Creation Popup
    Sleep    2  
    Input Text    xpath:.//*[@placeholder='請輸入欲新增標註類別名稱，字數上限 15 字元']    0123401234012345
    SeleniumLibrary.Page Should Contain Element    css:.form-erro
    SeleniumLibrary.Page Should Contain Element    css:button.stai-primary.disabled

SAA007
    [Documentation]    驗證標註類別名稱只能輸入1-15字，輸入1字名稱(測試案例編碼待改動)
    [Tags]    sidebar    Regression
    [Timeout]
    Clear Element Text    xpath:.//*[@placeholder='請輸入欲新增標註類別名稱，字數上限 15 字元']
    Input Text    xpath:.//*[@placeholder='請輸入欲新增標註類別名稱，字數上限 15 字元']    0
    Click Element    xpath:.//*[@type='submit']
    Sleep    1s 
    SeleniumLibrary.Page Should Contain Element    css:.stacked-toasts
    SeleniumLibrary.Page Should Contain Element    xpath=//span[text()='0']

SAA008
    [Documentation]    驗證標註類別名稱只能輸入1-15字，輸入null(測試案例編碼待改動)
    [Tags]    sidebar    Regression
    [Timeout]
    Sleep    1s
    Open Label Creation Popup
    Input Text    css:stai-form-field input    ${EMPTY}
    SeleniumLibrary.Page Should Contain Element    css:.form-erro
    SeleniumLibrary.Element Should Be Disabled    css:button.stai-primary.disabled

SAA009
    [Documentation]    驗證標註類別名稱只能輸入1-15字，輸入14字名稱(測試案例編碼待改動)
    [Tags]    sidebar    Regression
    [Timeout]
    Sleep    1s   
    Input Text    css:stai-form-field input    01234012340123
    Click Element    xpath:.//*[@type='submit']
    Sleep    1s 
    SeleniumLibrary.Page Should Contain Element    css:.stacked-toasts
    SeleniumLibrary.Page Should Contain Element    xpath=//span[text()='01234012340123']
