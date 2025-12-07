from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

chrome_options = Options()
chrome_options.add_experimental_option("detach", True)

service = Service(r"C:\chromedriver.exe")
driver = webdriver.Chrome(service=service, options=chrome_options)

driver.get("http://192.168.5.19:8019")

driver.add_cookie({
    "name": "token",
    "value": "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjBjYWQxNzA2LWE3MmMtNDQ1Mi05OTdlLTQ1YzZjZDY2MzZhNyIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxNzIuMjYuNTkuMzgiLCJOUElEIjoiIiwidXNpbmYiOiJIOXNDbEV1OVVsZzZ3a1c2a0gzbkc0RlpHTElKOWhUWEh5V1BlamxrNytxZzVKcDlxV0hpUEx5eDZ5Y096MkRjekY2SUU0enIza1N2SCt3Y2dvSUVaMU1LL0wwY1J6V0pRU3JpWGp1aURkZThmeHNuZW1zWDc3TTNvbCt4RTd6ZCIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTE2MTQ2NywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.8uthvvy1p2WbXI4HTRJcXYQrkJxB9Sk5DJsPuOP3BZs"
})
driver.refresh()
# 3) رفتن مستقیم به صفحه پذیرش بستری
driver.get("http://192.168.5.19:8019/filing")
driver.refresh()

wait = WebDriverWait(driver, 20)

NationalCode = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-3']"))
)
NationalCode.clear()
NationalCode.send_keys("1520554001")
NationalCode.send_keys(Keys.RETURN)

MobileNumber = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-31']"))
)

MobileNumber.clear()
MobileNumber.send_keys("09383509316")

Address = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-34']"))
)

Address.clear()
Address.send_keys("dfgdfgdfgd")

AccompanyfullName = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-35']"))
)

AccompanyfullName.clear()
AccompanyfullName.send_keys("مهرشاد شیخ الاسلامی")

AccompanyMobileNumber = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-36']"))
)
AccompanyMobileNumber.clear()
AccompanyMobileNumber.send_keys("09383586316")

AccompanyAddress = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-39']"))
)
AccompanyAddress.clear()
AccompanyAddress.send_keys("dfgdfgdfgd")

Copy_Btn = wait.until(
    EC.element_to_be_clickable((By.ID, "button-addon2"))
)
Copy_Btn.click()

# 1) کلیک روی فیلد
field = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "ng-select[formcontrolname='firstRecognition']"))
)
field.click()

# 2) پیدا کردن input داخل پانل بازشده (داخل body)
search_input = wait.until(
    EC.visibility_of_element_located((By.CSS_SELECTOR, "div.ng-dropdown-panel input[type='text']"))
)
search_input.send_keys("شکستگی")

# 3) صبر برای گزینه‌ای که شامل متن «شکستگی» است
option = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'شکستگی')]"))
)
option.click()

