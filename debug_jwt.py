import requests
import json
import logging
import subprocess # 确保subprocess被导入
import os

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_jwt_from_file():
    try:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            return json.load(f)['agentId']['jwt']
    except Exception as e:
        logging.error(f"Error reading JWT from file: {e}")
        return None

def test_jwt(jwt):
    if not jwt:
        return False
    test_url = "https://clawpi-v2.vercel.app/api/agent/profile" # Any JWT-protected endpoint
    headers = {"Authorization": f"Bearer {jwt}"}
    try:
        res = requests.get(test_url, headers=headers)
        if res.status_code == 200:
            logging.info("JWT seems valid.")
            return True
        else:
            logging.warning(f"JWT test failed: {res.status_code} - {res.text}")
            return False
    except Exception as e:
        logging.error(f"JWT test request failed: {e}")
        return False

# Main execution
print("--- 步骤 1: 从配置文件获取 JWT ---")
current_jwt = get_jwt_from_file()
if current_jwt:
    print("JWT 已从文件加载成功。")
    print("--- 步骤 2: 测试当前 JWT 有效性 ---")
    if test_jwt(current_jwt):
        print("当前 JWT 有效，无需刷新。")
    else:
        print("当前 JWT 无效或已过期，需要刷新。正在尝试重新初始化 FluxA CLI 以触发 JWT 刷新...")
        # 尝试重新初始化 FluxA CLI 来触发 JWT 刷新
        cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
        cmd = ["node", cli_path, "init", "--name", "小安CEO", "--email", "xiaohan@openclaw.ai", "--client", "OpenClaw v1.0"]
        try:
            print(f"执行命令: {' '.join(cmd)}")
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                print("FluxA CLI 初始化成功，请再次尝试运行任务。")
            else:
                print(f"FluxA CLI 初始化失败: {result.stderr or result.stdout}")
        except subprocess.TimeoutExpired:
            print("FluxA CLI 初始化超时。")
        except Exception as e:
            print(f"执行 FluxA CLI 初始化命令出错: {e}")
else:
    print("错误：未能从配置文件加载 JWT。")

