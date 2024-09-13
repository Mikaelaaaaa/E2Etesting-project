*** Settings ***
Documentation     An example resource file
# Library           
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary 

*** Variables ***
@{type_cn}=    分類資料集    實體資料集    OCR資料集    SR資料集

*** Keywords ***