
import time
import random
import json
import os
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

# --- Configuration ---
XHS_URL = "https://www.xiaohongshu.com/"
PROMOTIONAL_MESSAGES = [
    "发现好东西啦！更多爆款秘籍，尽在 baokuan.cc.cd",
    "最近挖到一个宝藏网站 baokuan.cc.cd，全是小红书爆款同款，快来看看！",
    "想知道爆款背后的小秘密吗？baokuan.cc.cd 让你先人一步！",
    "刷到这里说明你有眼光！baokuan.cc.cd 助你轻松掌握爆款趋势。",
    "别只看不点赞，真正的好货在 baokuan.cc.cd 等你哦！"
]
COOKIE_FILE = "xiaohongshu_cookies.json"
REPORT_FILE = "xiaohongshu_report.log"

# --- Anti-detection strategies ---
def get_chrome_options(headless_mode=True):
    options = Options()
    if headless_mode:
        options.add_argument("--headless")  # Run in headless mode
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("useAutomationExtension", False)
    options.add_argument(f"user-agent={generate_user_agent()}")
    # Add other stealth options as needed
    return options

def generate_user_agent():
    # A simple example, in a real scenario, use a library for diverse user agents
    user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/108.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15"
    ]
    return random.choice(user_agents)

def simulate_scroll_delay(driver):
    report_progress("Simulating scroll delay...")
    scroll_height = driver.execute_script("return document.body.scrollHeight")
    current_scroll = 0
    scroll_step = random.randint(300, 600)
    while current_scroll < scroll_height:
        driver.execute_script(f"window.scrollBy(0, {scroll_step});")
        current_scroll += scroll_step
        time.sleep(random.uniform(1, 3)) # Simulate human-like scroll delay
        scroll_height = driver.execute_script("return document.body.scrollHeight") # Update scroll height in case of lazy loading
        if random.random() < 0.3: # Randomly stop scrolling earlier
            break

def random_sleep():
    sleep_time = random.randint(15 * 60, 45 * 60) # 15 to 45 minutes
    report_progress(f"Sleeping for {sleep_time / 60:.2f} minutes...")
    time.sleep(sleep_time)

def load_cookies(driver, cookie_file):
    if os.path.exists(cookie_file):
        with open(cookie_file, 'r') as f:
            cookies = json.load(f)
        for cookie in cookies:
            # Ensure the cookie domain is correct for Xiaohongshu
            # And add other necessary keys if missing, like 'path'
            # For example, if 'domain' is missing, set it to ".xiaohongshu.com"
            if 'expiry' in cookie:
                del cookie['expiry'] # Selenium expects 'expirationDate' or no expiry
            driver.add_cookie(cookie)
        report_progress("Cookies loaded successfully.")
        return True
    else:
        report_progress(f"Cookie file '{cookie_file}' not found.")
        return False

def save_cookies(driver, cookie_file):
    with open(cookie_file, 'w') as f:
        json.dump(driver.get_cookies(), f)
    report_progress("Cookies saved successfully.")

def report_progress(message):
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    with open(REPORT_FILE, 'a', encoding='utf-8') as f:
        f.write(f"[{timestamp}] {message}\n")
    print(f"Report: {message}")

def find_and_comment_on_popular_notes(driver):
    report_progress("Searching for popular notes...")
    try:
        driver.get(XHS_URL)
        # Wait for the main feed to load. Adjust selector if needed.
        WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.CSS_SELECTOR, 'div.feed-item')))
        
        notes = driver.find_elements(By.CSS_SELECTOR, 'div.feed-item a') # Example selector for note links
        
        if not notes:
            report_progress("No notes found on the main feed initially. Scrolling to load more...")
            simulate_scroll_delay(driver)
            notes = driver.find_elements(By.CSS_SELECTOR, 'div.feed-item a')

        if notes:
            selected_note = random.choice(notes)
            note_url = selected_note.get_attribute('href')
            report_progress(f"Selected note for commenting: {note_url}")

            driver.get(note_url)
            # Wait for the note detail page and comment section to load
            WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.CSS_SELECTOR, '.comment-input textarea')))

            comment_box = driver.find_element(By.CSS_SELECTOR, '.comment-input textarea')
            comment_text = random.choice(PROMOTIONAL_MESSAGES)
            report_progress(f"Attempting to post comment: '{comment_text}'")

            # Simulate typing to avoid copy-paste detection
            for char in comment_text:
                comment_box.send_keys(char)
                time.sleep(random.uniform(0.05, 0.2)) # Tiny delay between characters

            time.sleep(random.uniform(1, 3)) # Human-like pause before submission

            # Find and click the submit button (adjust selector). Use JavaScript click as a fallback.
            try:
                submit_button = driver.find_element(By.CSS_SELECTOR, '.comment-input button.send-button')
                submit_button.click()
            except:
                driver.execute_script("document.querySelector('.comment-input button.send-button').click();")
            
            report_progress("Comment posted (attempted).")
            time.sleep(random.uniform(2, 5)) # Wait for submission to process

        else:
            report_progress("Could not find any notes to comment on after scrolling.")

    except Exception as e:
        report_progress(f"Error while finding and commenting on notes: {e}")
        # Optional: take a screenshot for debugging
        # driver.save_screenshot(f"error_screenshot_{time.time()}.png")

def main():
    # --- Initial Cookie Setup Guidance ---
    # If xiaohongshu_cookies.json does not exist, you will need to run the script once
    # with headless_mode=False to manually log in and save cookies. After saving,
    # you can set headless_mode=True for continuous background operation.
    
    # Set to False for initial manual login to generate cookies, then set back to True.
    initial_run_for_cookies = not os.path.exists(COOKIE_FILE)
    
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=get_chrome_options(not initial_run_for_cookies))

    try:
        driver.get(XHS_URL)

        if initial_run_for_cookies:
            report_progress("\n--- IMPORTANT: MANUAL LOGIN REQUIRED ---")
            report_progress(f"Please log in to Xiaohongshu manually in the opened browser window.")
            report_progress(f"Once logged in, DO NOT close the browser. Press Enter in the terminal to save cookies.")
            input("Press Enter after logging in successfully...")
            save_cookies(driver, COOKIE_FILE)
            report_progress("Cookies saved. Restarting script in headless mode for continuous operation.")
            driver.quit()
            # Restart the script (or re-initialize driver in headless mode)
            service = Service(ChromeDriverManager().install())
            driver = webdriver.Chrome(service=service, options=get_chrome_options(True))
            driver.get(XHS_URL) # Reload with headless driver
        
        # Try to load cookies regardless if it was an initial run or not
        cookies_loaded = load_cookies(driver, COOKIE_FILE)
        if cookies_loaded:
            driver.get(XHS_URL) # Reload with cookies to apply them
            WebDriverWait(driver, 20).until(EC.url_to_be(XHS_URL)) # Wait for the main page to load
        else:
            report_progress("Could not load cookies. Script cannot proceed without login data. Exiting.")
            return

        # Main operational loop
        while True:
            find_and_comment_on_popular_notes(driver)
            random_sleep() # Primary anti-ban sleep
            # simulate_scroll_delay(driver) # Simulate scrolling between major actions (can be inside find_and_comment_on_popular_notes)

    except Exception as e:
        report_progress(f"Critical error in main loop: {e}")
    finally:
        driver.quit()
        report_progress("Script finished or encountered an unrecoverable error. Check report.log for details.")

if __name__ == "__main__":
    main()
