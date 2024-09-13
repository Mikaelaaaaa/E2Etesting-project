*** Settings ***
Documentation    這是範例呦
Resource    ${CURDIR}/../resouces/PageDataSets.resource
Resource    ${CURDIR}/../resouces/general.resource
Library    ${CURDIR}/../Libraries/CustomSeleniumWireLibrary.py    WITH NAME    Custom
Library    SeleniumLibrary   
Suite Teardown   SeleniumLibrary.Close Browser
Test Teardown    Take Screenshot if Failed

*** Variables ***


*** Keywords ***


*** Test Cases ***
##先放在這裡但是之後整理進去
