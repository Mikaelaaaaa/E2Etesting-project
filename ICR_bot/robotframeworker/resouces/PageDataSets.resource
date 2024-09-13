*** Settings ***
Documentation     An example resource file 
# Library           
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary

*** Variables ***
@{type_cn}=    分類資料集    實體資料集    OCR資料集    SR資料集
@{language_list}=    繁體中文    英文

*** Keywords ***
Choose Dataset Type
    [Arguments]    ${type}
    Click Element    xpath:.//*[@placeholder="請選擇資料集類型"]
    ${index}=    Evaluate    ${type_cn}.index("${type}")
    Click Element    xpath://*[@id="mat-option-${index}"]//*

Choose Dataset Language    # SR資料集的時候不會用到,目前先選中文
    [Arguments]    ${language_list}
    Click Element    xpath:.//*[@placeholder="請選擇語系"]
    Click Element    xpath:.//span[contains(text(), '${language_list}')]
    Click Element    css=.cdk-overlay-container
Submit Dataset 
    Click Element    xpath=//button[@type='submit']

## 待整理
Open adding new dataset window
    Click Button    //button[contains(text(),'新增資料集')]
    Element Should Be Visible    //div[@class='modal-content']//puzzle-create-dataset-modal

Locate to the disable adding new button
    Element Should Be Disabled    //button[@type='submit']

Open the dropdown of dataset types
    Click Element    //mat-select[@id='mat-select-0']
 
Verify dropdown list result
    [Arguments]    ${dataset_type}
    Element Text Should Be    //div[@id='mat-select-value-1']    ${dataset type}

