import os
import shutil
from datetime import datetime
import random
from icecream import ic
import pyautogui
from seleniumwire import webdriver
from robot.api import logger
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager





class CustomSeleniumWireLibrary:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.driver = None

    def create_driver(self, position):
        options = webdriver.ChromeOptions()
        options.add_argument('--ignore-ssl-errors=yes')
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--disable-http2')
        options.add_argument("--disable-web-security")
        prefs = {'safebrowsing.enabled': 'true'}
        options.add_experimental_option("prefs", prefs)

        # Use ChromeDriverManager to automatically manage ChromeDriver
        service = Service(ChromeDriverManager().install())
        self.driver = webdriver.Chrome(service=service, options=options)

        # Set window position and size
        width, height = pyautogui.size()
        startY, startX = 0, 0
        if position == 'right':
            startX = width // 2

        self.driver.set_window_position(startX, startY)
        if position == "full_page":
            self.driver.set_window_size(width, height)
        else:
            self.driver.set_window_size(width // 2, height)

        self.driver.set_page_load_timeout(120)
        return self.driver

    def go_to(self, url):
        self.driver.get(url)

    def wait_elements_until(self, selector_para, depend='visible'):
        try:
            logger.debug('[wait_elements_until] ' + depend)
            index = selector_para.index(':')
            selector = selector_para[:index]
            selector_dict = {'css': By.CSS_SELECTOR, 'xpath': By.XPATH}
            selector = selector_dict.get(selector)
            para = selector_para[index + 1:]

            if depend == 'visible':
                WebDriverWait(self.driver, 30).until(EC.visibility_of_element_located((selector, para)))
            elif depend == 'clickable':
                WebDriverWait(self.driver, 30).until(EC.element_to_be_clickable((selector, para)))
            else:
                WebDriverWait(self.driver, 30).until(EC.presence_of_element_located((selector, para)))

            elements = self.driver.find_elements(selector, para)
            logger.debug("[wait_elements_until] elements get!")
            return elements

        except Exception as e:
            logger.error('[wait_elements_until] error')
            logger.error(e)
            return None
        
    def click(self,selector_para,depend='clickable'):#預設等待clickable再進行點擊
        ele=self.wait_element_until(selector_para,depend)
        ele.click()
        logger.debug('clicked')

    def wait_element_until(self, selector_para, depend='visible'):
        try:
            logger.debug('[wait_element_until] ' + depend)
            index = selector_para.index(':')
            selector = selector_para[:index]
            selector_dict = {'css': By.CSS_SELECTOR, 'xpath': By.XPATH}
            selector = selector_dict.get(selector)
            para = selector_para[index + 1:]

            if depend == 'visible':
                element = WebDriverWait(self.driver, 30).until(EC.visibility_of_element_located((selector, para)))
            elif depend == 'clickable':
                element = WebDriverWait(self.driver, 30).until(EC.element_to_be_clickable((selector, para)))
            else:
                element = WebDriverWait(self.driver, 30).until(EC.presence_of_element_located((selector, para)))

            logger.debug("[wait_element_until] element get!")
            return element

        except Exception as e:
            logger.error('[wait_element_until] error')
            logger.error(e)
            return None

    def switch_tab(self):
        chwd = self.driver.window_handles
        p = self.driver.current_window_handle
        for w in chwd:
            if w != p:
                self.driver.switch_to.window(w)
        logger.debug('[switch_tab] success')

    def get_requests(self):
        return self.driver.requests

    
    def scroll_to_element(self, selector_para, depend='visible'):
        element = self.wait_element_until(selector_para, depend)
    
        if element:
            ActionChains(self.driver).scroll_to_element(element).perform()
            logger.debug(f'Scrolled to element with selector: {selector_para}')
        else:
            logger.error(f'Element with selector {selector_para} not found or not in the expected state')

    def close_browser(self):
        if self.driver:
            self.driver.quit()

    def is_displayed(self, selector_para):
        element = self.wait_element_until(selector_para, 'visible')
        return element.is_displayed()

    def move_to(self, selector_para, depend='visible'):
        action = ActionChains(self.driver)
        element = self.wait_element_until(selector_para, depend)
        action.move_to_element(element).perform()

    def load_env_var(self, key):
        result = os.environ.get(key, None)
        if not result:
            logger.error('[load_env_var] not found key')

    def is_empty(self, selector_para):
        ele = self.wait_element_until(selector_para, 'visible')
        son = ele.find_elements(By.XPATH, './/*')
        if not son:
            return True
        return (son[0].get_attribute('outerHTML'), son[0].get_attribute('innerHTML'), len(list(son)))

    def clear_input(self, selector_para):
        self.wait_element_until(selector_para).clear()

    def get_check_code(self):
        for request in self.driver.requests:
            if 'recaptcha' in request.url:
                import json
                data = json.loads(request.response.body.decode())
                logger.debug(data.get('captchaCode', ''))
                return data.get('captchaCode', '')

    def log_in_to_systalk(self, username, password):
        self.wait_elements_until('css:[placeholder]')[0].send_keys(username)
        self.wait_elements_until('css:[placeholder]')[1].send_keys(password)
        checkCode = self.get_check_code()
        logger.debug(f"checkCode: {checkCode}")
        self.wait_elements_until('css:[placeholder]')[2].send_keys(checkCode)
        self.wait_element_until('css:[type=submit]', 'clickable').click()
        logger.debug("submitted!")

    def go_to_puzzle(self):
        action = ActionChains(self.driver)
        element = self.wait_element_until("css:#productHover")
        action.move_to_element(element).perform()
        self.wait_element_until('css:#productButtons > button', 'clickable').click()
        logger.debug("go_to_database - done")
        

    # 能不用自己寫關鍵字就靠這次了qq
    def get_complete_url(self):
        for request in self.driver.requests:
            if '/api/v1/auth/authorize' in request.url:
                import json
                try:
                    response_data = json.loads(request.response.body.decode())
                    code = response_data.get('code')
                    redirectUrl = response_data.get('redirectUrl')
                    if code and redirectUrl:
                        complete_url = f"{redirectUrl}?code={code}"
                        logger.debug(f"Complete URL: {complete_url}")
                        return complete_url  
                except Exception as e:
                    logger.error(f"Error parsing response: {e}")

        logger.error('No redirect URL found in response')
        return None

    def random(self, length):
        return ''.join(random.sample('1234567890abcdefghijklmnopqrstuvwxyz', int(length)))
    


