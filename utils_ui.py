from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.action_chains import ActionChains

# ️⃣ هندل کردن Spinner
def wait_for_spinner_to_hide(driver, timeout=30):
    wait = WebDriverWait(driver, timeout)
    try:
        wait.until(lambda d: all(
            s.value_of_css_property("display") == "none" or s.value_of_css_property("opacity") == "0"
            for s in d.find_elements(By.CSS_SELECTOR, "div.back-spenner")
        ))
    except TimeoutException:
        spinners = driver.find_elements(By.CSS_SELECTOR, "div.back-spenner")
        print(f"⚠️ Spinner timeout after {timeout}s, count={len(spinners)}")
        for i, s in enumerate(spinners):
            print(f"Spinner[{i}] HTML:\n{s.get_attribute('outerHTML')}\n")
        raise
    print("✅ Spinner fully hidden.")


#  SweetAlert هندل
def handle_sweetalert(driver, timeout=15):
    wait = WebDriverWait(driver, timeout)
    deny_btn = wait.until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, "button.swal2-deny.swal2-styled"))
    )
    ActionChains(driver).move_to_element(deny_btn).pause(0.3).click().perform()
    wait.until(EC.invisibility_of_element_located(
        (By.CSS_SELECTOR, "div.swal2-container.swal2-center"))
    )
    wait_for_spinner_to_hide(driver)
    print("✅ SweetAlert handled and closed.")


# ️⃣ ناوبری به بیماران بستری
def navigate_to_inpatients(driver, timeout=30):
    wait = WebDriverWait(driver, timeout)

    menu_inpatient = wait.until(
        EC.element_to_be_clickable(
            (By.XPATH, "//img[@src='assets/icons/inpatient.svg']/ancestor::a")
        )
    )
    ActionChains(driver).move_to_element(menu_inpatient).pause(0.2).click().perform()

    wait.until(
        EC.visibility_of_element_located(
            (By.XPATH, "(//span[contains(@class,'title-header') and contains(text(),'بیماران بستری')])[1]")
        )
    )

    print("✅ Navigated to 'بیماران بستری' page successfully.")
