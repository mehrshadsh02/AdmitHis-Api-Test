from selenium import webdriver
from selenium.common import TimeoutException
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains

chrome_options = Options()
chrome_options.add_experimental_option("detach", True)

service = Service(r"C:\chromedriver.exe")
driver = webdriver.Chrome(service=service, options=chrome_options)

driver.get("http://192.168.5.19:8019")

driver.add_cookie({
    "name": "token",
    "value": "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjYxZmQ4ZmIyLWJkYjMtNDQ2NS04MjRlLTJhM2Y2MTg2MmQ2MCIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjIiLCJOUElEIjoiIiwidXNpbmYiOiJSRVEyY0R1MjcxNEN3RWZGU0hEMTVmazhoeTRUM09UalJoNS9ibWZ3OHR0K0FUWjNPVlV4THUrdm1VUnRnQW8zQ3RKV2Nmc1hVVUMzaUUzRXRyTWJsd1V0NjAwQW9nQ0RaZFVjVnNDS0thUXVPaVNZTUJEUGJEQW9ZVUpKNGx4NiIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTMyNTU3NSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.m-lOF9OKBTSIQJ8ho83v6DfPSWtK0GJP2sVeWUYrI9I"
})
driver.refresh()

#  رفتن مستقیم به صفحه پذیرش بستری

driver.get("http://192.168.5.19:8019/filing")
driver.refresh()

wait = WebDriverWait(driver, 20)

NationalCode = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-3']"))
)
NationalCode.clear()
NationalCode.send_keys("1520554001")
NationalCode.send_keys(Keys.RETURN)

# 🔻 صبر تا زمانی که (لودینگ) ناپدید بشه

wait.until(EC.invisibility_of_element_located(
    (By.CSS_SELECTOR, "div.back-spenner.ng-star-inserted"))
)

# انتخاب وضعیت تاهل از لیست
select_field_maritalStatus = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='maritalStatus']")
select_field_maritalStatus.click()

input_field_maritalStatus = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='maritalStatus'] input[type='text']")
input_field_maritalStatus.send_keys("مجرد")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'مجرد')]"))
)
option_to_pick.click()

# انتخاب ارتباط با بیمه شده از لیست
select_field_insurRelation = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='insurRelation']")
select_field_insurRelation.click()

input_field_insurRelation = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='insurRelation'] input[type='text']")
input_field_insurRelation.send_keys("خود فرد")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'خود فرد')]"))
)
option_to_pick.click()

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

# کپی ادرس
Copy_Btn = wait.until(
    EC.element_to_be_clickable((By.ID, "button-addon2"))
)
Copy_Btn.click()

# انتخاب تشخیص اولیه از لیست
select_field_firstRecognition = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='firstRecognition']")
select_field_firstRecognition.click()

input_field_firstRecognition = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='firstRecognition'] input[type='text']")
input_field_firstRecognition.send_keys("شکستگی")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'شکستگی')]"))
)
option_to_pick.click()

# انتخاب نحوه مراجعه از لیست
select_field_howToRefer = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='howToRefer']")
select_field_howToRefer.click()

input_field_howToRefer = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='howToRefer'] input[type='text']")
input_field_howToRefer.send_keys("وسیله شخصی")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'وسیله شخصی')]"))
)
option_to_pick.click()

# انتخاب علت بستری از لیست
select_field_causeOfHospitalization = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='causeOfHospitalization']")
select_field_causeOfHospitalization.click()

input_field_causeOfHospitalization = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='causeOfHospitalization'] input[type='text']")
input_field_causeOfHospitalization.send_keys("دل درد")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'دل درد')]"))
)
option_to_pick.click()

# انتخاب بخش بستری از لیست
select_field_wardfileld = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='wardfileld']")
select_field_wardfileld.click()

input_field_wardfileld = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='wardfileld'] input[type='text']")
input_field_wardfileld.send_keys("اطفال 2 - تخت خالی (33)")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'اطفال 2 - تخت خالی (33)')]"))
)
option_to_pick.click()

wait.until(EC.invisibility_of_element_located(
    (By.CSS_SELECTOR, "div.back-spenner.ng-star-inserted"))
)

# انتخاب پزسک بستری از لیست
select_field_doctorField = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='doctorField']")
select_field_doctorField.click()

input_field_doctorField = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='doctorField'] input[type='text']")
input_field_doctorField.send_keys("Siavash Siavash")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'Siavash Siavash')]"))
)
option_to_pick.click()

# انتخاب مسئول بیمار از لیست
select_field_responsiblePatient = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='responsiblePatient']")
select_field_responsiblePatient.click()

input_field_responsiblePatient = driver.find_element(By.CSS_SELECTOR, "ng-select[formcontrolname='responsiblePatient'] input[type='text']")
input_field_responsiblePatient.send_keys("خود فرد")

wait = WebDriverWait(driver, 10)
option_to_pick = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//div[contains(@class,'ng-option') and contains(., 'خود فرد')]"))
)
option_to_pick.click()

# تعیین پیش پرداخت

prepayment = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-40']"))
)

prepayment.clear()
prepayment.send_keys("10000")

Address = wait.until(
    EC.visibility_of_element_located((By.XPATH, "//input[@id='mat-input-40']"))
)
# زدن دکمه Save
Save_Btn = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "button.btn-saveFile"))
)
Save_Btn.click()
wait.until(EC.invisibility_of_element_located(
    (By.CSS_SELECTOR, "div.back-spenner.ng-star-inserted"))
)
try:
    wait.until(EC.invisibility_of_element_located(
        (By.CSS_SELECTOR, "div.back-spenner.ng-star-inserted"))
    )
except TimeoutException:
    # تست تشخیصی:
    spinners = driver.find_elements(By.CSS_SELECTOR, "div.back-spenner")
    print(f"Spinner count at timeout: {len(spinners)}")
    if spinners:
        print("Spinner HTML:", spinners[0].get_attribute("outerHTML"))
    else:
        print("Spinner not found but still TimeoutException!")
    raise

#  صبر میکنیم تا دکمه لغو خودش بیاد بالا
# wait.until(EC.visibility_of_element_located(
#     (By.CSS_SELECTOR, "div.swal2-popup.swal2-modal")
# ))

Deny_Btn = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "button.swal2-deny.swal2-styled"))
)
# Deny_Btn.click()

#   کمی breathing room برای انیمیشن SweetAlert بگذار
WebDriverWait(driver, 3).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "button.swal2-deny.swal2-styled"))
)

#  اجرای کلیک به‌صورت واقعی با ActionChains (فوق‌العاده برای overlayها)
ActionChains(driver)\
    .move_to_element(Deny_Btn)\
    .pause(0.3)\
    .click()\
    .perform()

# منتظر شو Alert و Spinner ناپدید بشن
wait.until(EC.invisibility_of_element_located(
    (By.CSS_SELECTOR, "div.swal2-container.swal2-center"))
)
wait.until(EC.invisibility_of_element_located(
    (By.CSS_SELECTOR, "div.back-spenner.ng-star-inserted"))
)