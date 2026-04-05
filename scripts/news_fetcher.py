import json
import subprocess
import smtplib
import re
from email.mime.text import MIMEText
from email.utils import formataddr

def fetch_news(query):
    cmd = ["mcporter", "call", "tavily.tavily_search", f"query={query}"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        data = json.loads(result.stdout)
        results = data.get('results', [])
        clean_news = []
        for n in results:
            # 简单清洗
            title = re.sub(r'#+', '', n.get('title', ''))
            content = re.sub(r'http\S+', '', n.get('content', '')).strip()
            clean_news.append(f"● {title}\n  {content[:60]}...")
        return clean_news
    except: return []

def get_metals():
    # 强制搜索明确的现货价格摘要
    cmd = ["mcporter", "call", "tavily.tavily_search", "query=今日国内黄金现货价格 人民币每克 请直接给出具体数字"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        data = json.loads(result.stdout)
        # 尝试正则提取价格
        text = str(data.get('results', [{}])[0].get('content', ''))
        matches = re.findall(r'\d{3,4}\.?\d*', text)
        return f"当前黄金现货参考价：{matches[0]} 元/克" if matches else "行情接口波动，暂未抓取到价格"
    except: return "价格获取失败"

def send_email(subject, content):
    smtp_server = "smtp.qq.com"
    smtp_port = 465
    sender = "14986860@qq.com"
    password = "mdnytzlhgbeubgig"
    receiver = "5581223@qq.com"
    
    msg = MIMEText(content, 'plain', 'utf-8')
    msg['From'] = formataddr(('小安 CEO', sender))
    msg['To'] = formataddr(('老板', receiver))
    msg['Subject'] = subject
    
    server = smtplib.SMTP_SSL(smtp_server, smtp_port)
    server.login(sender, password)
    server.sendmail(sender, [receiver], msg.as_string())
    server.quit()

def main():
    domestic = fetch_news("2026年3月20日 国内新闻头条")
    international = fetch_news("2026年3月20日 国际财经头条")
    metals = get_metals()
    
    content = f"【贵金属行情】\n{metals}\n\n"
    content += "【国内要闻】\n" + "\n".join(domestic[:5])
    content += "\n\n【国际要闻】\n" + "\n".join(international[:5])
    
    send_email("每日早报 07:30 - 高效清洗版", content)

if __name__ == "__main__":
    main()
EOF
python3 /root/.openclaw/workspace/scripts/news_fetcher.py