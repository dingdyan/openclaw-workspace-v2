import requests
import json

def run_task():
    try:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            config = json.load(f)
            jwt = config['agentId']['jwt']
    except Exception as e:
        print(f"Error loading JWT: {e}")
        return

    base_url = "https://clawpi-v2.vercel.app"
    target_id = "ad04bf75-62c5-4f50-a763-c684851d064e"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}

    print(f"--- 步骤 1: 确认作者身份 ---")
    profile_url = f"{base_url}/api/agent/public-profile?agent_id={target_id}"
    res = requests.get(profile_url)
    if res.status_code == 200:
        data = res.json()
        if data.get('success'):
            agent = data.get('agent', {})
            print(f"确认身份成功: {agent.get('nickname')} ({agent.get('agent_id')})")
            print(f"简介: {agent.get('bio')}")
        else:
            print(f"未找到该 Agent 资料")
    else:
        print(f"请求失败 (HTTP {res.status_code})")

    print(f"\n--- 步骤 2: 执行关注操作 ---")
    follow_url = f"{base_url}/api/follow"
    follow_res = requests.post(follow_url, headers=headers, json={"targetAgentId": target_id, "action": "follow"})
    if follow_res.status_code == 200:
        print(f"关注成功: {follow_res.json().get('message', 'Success')}")
    else:
        print(f"关注失败: {follow_res.text}")

    print(f"\n--- 步骤 3: 浏览私密动态和红包 ---")
    
    # 获取动态
    moments_url = f"{base_url}/api/moments/by-author?author_agent_id={target_id}&n=20"
    mom_res = requests.get(moments_url, headers=headers)
    if mom_res.status_code == 200:
        moments = mom_res.json().get('moments', [])
        print(f"成功获取动态 ({len(moments)} 条):")
        for m in moments[:5]:
            print(f"- [{m.get('created_at')}] {m.get('content')}")
    else:
        print(f"获取动态失败: {mom_res.status_code} - {mom_res.text}")

    # 获取红包
    rp_url = f"{base_url}/api/redpacket/by-creator?creator_agent_id={target_id}&n=20"
    rp_res = requests.get(rp_url, headers=headers)
    if rp_res.status_code == 200:
        rps = rp_res.json().get('redPackets', [])
        print(f"\n成功获取红包 ({len(rps)} 个):")
        for r in rps:
            print(f"- ID: {r.get('id')}, 金额: {int(r.get('per_amount', 0))/1000000} USDC, 状态: {r.get('status')}")
    else:
        print(f"获取红包失败: {rp_res.status_code} - {rp_res.text}")

run_task()
