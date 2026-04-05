from scrapling.fetchers import StealthyFetcher
import logging

logging.basicConfig(level=logging.INFO)
fetcher = StealthyFetcher(adaptive=True)

# 使用公共测试站点验证反爬绕过能力
url = "https://quotes.toscrape.com"
page = fetcher.fetch(url, headless=True)

print(f"Status: {page.status_code}")
print(f"Title: {page.css('title::text').get()}")
print(f"Body snippet: {page.css('.quote .text::text').getall()[:2]}")
